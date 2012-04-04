Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2DDPm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:42:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57722 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab2DDPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:42:27 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <m2y5qdow0v.fsf@igel.home>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca> <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home> <20120402202848.1EB833E02A7@localhost> <m2y5qdow0v.fsf@igel.home>
Date: Wed, 04 Apr 2012 08:40:20 -0700
Message-Id: <20120404154020.40C513E09D5@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2012 14:11:12 +0200, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
> 
> > Can you dump out /debug/powerpc/virq_mapping from both before and
> > after the irq_map patch is applied?
> 
> before:
> virq   hwirq    chip name        chip data           host name
>    16  0x00000   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    21  0x00001   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    24  0x00002   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    25  0x00019   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    26  0x0001a   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    27  0x0001b   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    28  0x0001c   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    29  0x0003d   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    30  0x0001e   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    31  0x0003c   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    39  0x00027   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    40  0x00028   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    41  0x00029   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    42  0x0002a   MPIC 2          0xc00000017a011000  /u3@0,f8000000/mpic@f8040000
>    47  0x0002f   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    59  0x000fb   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    60  0x000fc   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    61  0x000fd   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    62  0x000fe   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    63  0x0003f   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
> 
> after:
> virq   hwirq    chip name        chip data           host name
>    16  0x00000   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    21  0x00001   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    24  0x00002   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    25  0x00019   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    26  0x0001a   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    27  0x0001b   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    28  0x0001c   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    30  0x0001e   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    39  0x00027   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    40  0x00028   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    41  0x00029   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    42  0x0002a   MPIC 2          0xc00000017a011000  /u3@0,f8000000/mpic@f8040000
>    47  0x0002f   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    59  0x000fb   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    60  0x000fc   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    61  0x000fd   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    62  0x000fe   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    63  0x0003f   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    64  0x0003d   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
>    65  0x0003c   MPIC 1          0xc00000017a010000  /ht@0,f2000000/pci@1/mac-io@7/mpic@40000
> 
> But I have NR_IRQS=64.  Bounds checking missing?  Irqs 64/65 are related
> to the sound chip (headphone-detect and line-out-detect).

I bet it is NR_IRQS related.  You have SPARSE_IRQ enabled, which means
the maximum number of irq_descs is IRQ_BITMAP_BITS (NR_IRQS + 8192).
The old powerpc code was strictly limited to NR_IRQS, but the new code
uses irq_alloc_descs() which isn't.  Yet I can see places in the
powerpc code that depends specifically on the value of NR_IRQS.  The
for_each_irq() macro for instance.  I think all the users there can be
switched to using for_each_irq_desc().

Can you attach console output logs for each of configs above and also
with NR_IRQS=128?  That might give me some clues as to which specific
code is causing the issues.  Also, as a quick test, try changing
for_each_irq_desc() to use "nr_irqs" instead of "NR_IRQS".  nr_irqs is
kept up to date with the real maximum number of irqs allocated in the
system:

diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index cf417e51..9edf499 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -20,7 +20,7 @@
 
 /* Define a way to iterate across irqs. */
 #define for_each_irq(i) \
-       for ((i) = 0; (i) < NR_IRQS; ++(i))
+       for ((i) = 0; (i) < nr_irqs; ++(i))
 
 extern atomic_t ppc_n_lost_interrupts;
 

g.

> 
> When reconfiguring with NR_IRQS=128 interrupts are working again, but I
> still see a lot of spurious interrupts, and the X server is still broken
> (no input works, but I still don't know whether that is an unrelated
> bug).
> 
> This is a sample of /proc/interrupts from 3.3 (with NR_IRQS=64):
>            CPU0       CPU1       
>  16:       2039       6070   MPIC 1    Level     sata_svw
>  21:          0          0   MPIC 1    Edge      i2sbus: i2s-a (tx)
>  22:         12         20   MPIC 1    Level   
>  23:         14         18   MPIC 1    Level   
>  24:          0          0   MPIC 1    Edge      i2sbus: i2s-a (rx)
>  25:          3          0   MPIC 1    Level     VIA-PMU
>  26:         16         62   MPIC 1    Level     keywest i2c
>  27:          0          1   MPIC 1    Level     ohci_hcd:usb2
>  28:          0          1   MPIC 1    Level     ohci_hcd:usb3
>  29:          0          0   MPIC 1    Edge      headphone-detect
>  30:          0          0   MPIC 1    Level     i2sbus: i2s-a (control)
>  31:          0          0   MPIC 1    Edge      line-output-detect
>  39:         22         64   MPIC 1    Level     pata-pci-macio
>  40:          0          2   MPIC 1    Level     firewire_ohci
>  41:         52        147   MPIC 1    Level     eth0
>  42:       1732       5053   MPIC 2    Level     keywest i2c
>  47:          0          0   MPIC 1    Level     GPIO1 ADB
>  59:          0          0   MPIC 1    Edge      ipi call function
>  60:       2064       1940   MPIC 1    Edge      ipi reschedule
>  61:       3406        945   MPIC 1    Edge      ipi call function single
>  62:          0          0   MPIC 1    Edge      ipi debugger
>  63:         39         91   MPIC 1    Level     ehci_hcd:usb1, ohci_hcd:usb4, ohci_hcd:usb5
> LOC:       3503       3719   Local timer interrupts
> SPU:          2          0   Spurious interrupts
> CNT:          0          0   Performance monitoring interrupts
> MCE:          0          0   Machine check exceptions
> 
> This is a sample of /proc/interrupts from 3.4-rc1 (with NR_IRQS=128):
>            CPU0       CPU1       
>  16:       2603       7596   MPIC 1    Level     sata_svw
>  21:          1          0   MPIC 1    Edge      i2sbus: i2s-a (tx)
>  22:         13         19   MPIC 1    Level   
>  23:          8         24   MPIC 1    Level   
>  24:          0          1   MPIC 1    Edge      i2sbus: i2s-a (rx)
>  25:          2          1   MPIC 1    Level     VIA-PMU
>  26:         21         57   MPIC 1    Level     keywest i2c
>  27:          0          1   MPIC 1    Level     ohci_hcd:usb2
>  28:          0          1   MPIC 1    Level     ohci_hcd:usb3
>  30:          0          0   MPIC 1    Level     i2sbus: i2s-a (control)
>  39:         39        131   MPIC 1    Level     pata-pci-macio
>  40:          2          2   MPIC 1    Level     firewire_ohci
>  41:         93        268   MPIC 1    Level     eth0
>  42:       8569      24140   MPIC 2    Level     keywest i2c
>  47:          0          0   MPIC 1    Level     GPIO1 ADB
>  60:          1          0   MPIC 1    Edge      line-output-detect
>  61:          1          0   MPIC 1    Edge      headphone-detect
>  63:        153        502   MPIC 1    Level     ehci_hcd:usb1, ohci_hcd:usb4, ohci_hcd:usb5
> 123:          0          0   MPIC 1    Edge      ipi call function
> 124:       1978       2349   MPIC 1    Edge      ipi reschedule
> 125:       2356       1816   MPIC 1    Edge      ipi call function single
> 126:          0          0   MPIC 1    Edge      ipi debugger
> LOC:       4417       7985   Local timer interrupts
> SPU:       9586      25811   Spurious interrupts
> CNT:          0          0   Performance monitoring interrupts
> MCE:          0          0   Machine check exceptions
> 
> Andreas.
> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
