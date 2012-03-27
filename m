Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2C0KLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:11:43 -0400
Received: from gold.linx.net ([195.66.232.40]:54949 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab2C0KLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:11:42 -0400
Message-ID: <4F719262.7090008@linx.net>
Date: Tue, 27 Mar 2012 11:11:46 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120326 Thunderbird/11.0
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie> <4F70764F.7030409@linx.net> <20120326143250.GN4014@phenom.ffwll.local> <4F707F05.7000401@linx.net> <20120327100128.GF4276@phenom.ffwll.local>
In-Reply-To: <20120327100128.GF4276@phenom.ffwll.local>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 27/03/12 11:01, Daniel Vetter wrote:
> Another thing for you to try is booting with
> i915.i915_enable_ppgtt=0 (and vt-d enabled of course).

That appears to be a winner:
adrastea ~ # uname -a
Linux adrastea 3.3.0-06972-ge22057c #1 SMP PREEMPT Tue Mar 27 11:06:46
BST 2012 x86_64 Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz GenuineIntel
GNU/Linux
adrastea ~ # cat /proc/cmdline
auto BOOT_IMAGE=3.3.0-06972-ge2 rw root=0 i915.i915_enable_ppgtt=0
adrastea ~ #

VT-d is enabled, as evidenced by DMAR entries:
adrastea ~ # cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:        126          0          0          0  IR-IO-APIC-edge
 timer
  1:          8          0          0          0  IR-IO-APIC-edge
 i8042
  7:          1          0          0          0  IR-IO-APIC-edge
 parport0
  8:         32          0          0          0  IR-IO-APIC-edge
 rtc0
  9:        113          0          0          0  IR-IO-APIC-fasteoi
 acpi
 12:        291          0          0          0  IR-IO-APIC-edge
 i8042
 19:         35          0          0          0  IR-IO-APIC-fasteoi
 mmc0
 22:        613          0          0          0  IR-IO-APIC-fasteoi
 ehci_hcd:usb2
 23:      16052          0          0          0  IR-IO-APIC-fasteoi
 ehci_hcd:usb1
 40:          0          0          0          0  DMAR_MSI-edge      dmar0
 41:          0          0          0          0  DMAR_MSI-edge      dmar1
 42:       1167          0          0          0  IR-PCI-MSI-edge
 i915
 43:       9622          0          0          0  IR-PCI-MSI-edge
 ahci
 44:       1536          0          0          0  IR-PCI-MSI-edge
 eth0
 45:       4577          0          0          0  IR-PCI-MSI-edge
 iwlwifi
 46:          1          0          0          0  IR-PCI-MSI-edge
 xhci_hcd
 47:          0          0          0          0  IR-PCI-MSI-edge
 xhci_hcd
 48:          0          0          0          0  IR-PCI-MSI-edge
 xhci_hcd
 49:          0          0          0          0  IR-PCI-MSI-edge
 xhci_hcd
 50:          0          0          0          0  IR-PCI-MSI-edge
 xhci_hcd
 51:         23          0          0          0  IR-PCI-MSI-edge      mei
 52:       1518          0          0          0  IR-PCI-MSI-edge
 snd_hda_intel
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      17667      13603      17854       6331   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance
monitoring interrupts
IWI:          0          0          0          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:       8771       6319        632        370   Rescheduling interrupts
CAL:         51         59         31         52   Function call
interrupts
TLB:       1363        819       1346        227   TLB shootdowns
TRM:          0          0          0          0   Thermal event
interrupts
THR:          0          0          0          0   Threshold APIC
interrupts
MCE:          0          0          0          0   Machine check
exceptions
MCP:          2          2          2          2   Machine check polls
ERR:          0
MIS:          0

No DMAR complaints in dmesg yet; it would have crashed by now if the
fault was present.

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9xkmIACgkQp5vW4rUFj5oZhACfSBIL3TTnQP1ST7QI2jUsb+Dk
ZQEAn0CGx3gzw/K/it/kIMml1EFR9PJV
=CJ6X
-----END PGP SIGNATURE-----
