Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0F3QGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:06:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46105 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab0F3QGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:06:04 -0400
X-Authority-Analysis: v=1.1 cv=jfMbZ+4tkgrYlaJBi3iJCtg6TDszHDHJJpQ3TdTfnr0= c=1 sm=0 a=u8eIACkqEOAA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=hUFju7MpbL9V07b6t1cA:9 a=yMrNMGNC5eBQuCWL83Af25wqJK4A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] kacpi_notify goes into an infinite loop (luckly it calls
 cond_resched)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, "clarkt@cnsp.com" <clarkt@cnsp.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006301115370.3989@localhost.localdomain>
References: <1275094882.22648.607.camel@gandalf.stny.rr.com>
	 <1275274670.9119.4419.camel@rzhang1-desktop>
	 <1277905208.24800.21.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1006301115370.3989@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 30 Jun 2010 12:06:00 -0400
Message-ID: <1277913960.24800.31.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 11:17 -0400, Len Brown wrote:
> > /sys/firmware/acpi/interrupts/sci_not:       1
> 
> This means that acpi_irq was invoked and could not find a cause for the 
> interrupt.
> 
> Does /proc/interrupts show that the acpi interrupt shares and IRQ
> with another device, or is it alone?
> 

It looks to be alone:

# cat /proc/interrupts 
            CPU0       
   0:        158   IO-APIC-edge      timer
   1:        334   IO-APIC-edge      i8042
   4:          4   IO-APIC-edge    
   6:          5   IO-APIC-edge      floppy
   7:          0   IO-APIC-edge      parport0
   8:          0   IO-APIC-edge      rtc0
   9:          0   IO-APIC-fasteoi   acpi
  12:     238565   IO-APIC-edge      i8042
  14:     158753   IO-APIC-edge      ata_piix
  15:     604816   IO-APIC-edge      ata_piix
  16:      38352   IO-APIC-fasteoi   uhci_hcd:usb2, i915@pci:0000:00:02.0
  17:       3164   IO-APIC-fasteoi   Intel 82801DB-ICH4, eth0
  18:          0   IO-APIC-fasteoi   uhci_hcd:usb4
  19:    1652995   IO-APIC-fasteoi   uhci_hcd:usb3
  23:    3718117   IO-APIC-fasteoi   ehci_hcd:usb1
 NMI:      16288   Non-maskable interrupts
 LOC:    7599309   Local timer interrupts
 SPU:          0   Spurious interrupts
 PMI:          0   Performance monitoring interrupts
 PND:          0   Performance pending work
 RES:          0   Rescheduling interrupts
 CAL:          0   Function call interrupts
 TLB:          0   TLB shootdowns
 TRM:          0   Thermal event interrupts
 THR:          0   Threshold APIC interrupts
 MCE:          0   Machine check exceptions
 MCP:        523   Machine check polls
 ERR:          6
 MIS:          0

-- Steve


