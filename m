Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1BJT60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:58:26 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35547 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1BJT6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:58:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UFN6lD2puNF56Ep33AK7S/R9apFa7fogxjuv7IPwLT2m4gIdxWbQbUuHnbr4bQSS+r
         vOxqZnGtwpuZXL2vPPJx5W+nM0O2lP5efuZQjLixQYZka6f0V3XLcGY7SXAUujjiW8YA
         Glwug4PDzYwgZo2VBa3pggV3v/k+2CsheF09Y=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Handle the no-interrupts case for UMS by polling
Date: Thu, 10 Feb 2011 19:58:12 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201101231128.22951.chris2553@googlemail.com> <201101231538.41929.chris2553@googlemail.com> <0d30dc$kr9795@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$kr9795@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102101958.12842.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Sunday 23 January 2011, Chris Wilson wrote:
> On Sun, 23 Jan 2011 15:38:41 +0000, Chris Clayton <chris2553@googlemail.com> 
wrote:

<snip>

> > I guess we may be working with slightly different versions of the source.
> >
> > 2. The kernel log now contains the following:
> >
> > r8169 0000:02:00.0: eth0: link up
> > [drm] Initialized drm 1.1.0 20060810
> > irq 16: nobody cared (try booting with the "irqpoll" option)
> > Pid: 0, comm: kworker/0:1 Not tainted 2.6.38-rc2+ #502
> > Call Trace:
> >  [<c1070a54>] ? __report_bad_irq.clone.2+0x24/0x90
> >  [<c1070c17>] ? note_interrupt+0x157/0x190
> >  [<c101b1cd>] ? ack_apic_level+0x5d/0x1e0
> >  [<c107175b>] ? handle_fasteoi_irq+0xab/0xd0
> >  [<c10716b0>] ? handle_fasteoi_irq+0x0/0xd0
> >  <IRQ>  [<c1004ddd>] ? do_IRQ+0x3d/0xc0
> >  [<c1037f27>] ? irq_exit+0x57/0x70
> >  [<c1019173>] ? smp_apic_timer_interrupt+0x53/0x90
> >  [<c1003229>] ? common_interrupt+0x29/0x30
> >  [<c119fbe9>] ? acpi_safe_halt+0x19/0x26
> >  [<c119fc50>] ? acpi_idle_enter_c1+0x5a/0xa9
> >  [<c1244d98>] ? cpuidle_idle_call+0x68/0xf0
> >  [<c1001726>] ? cpu_idle+0x46/0x80
> > handlers:
> > [<c129dd60>] (azx_interrupt+0x0/0x180)
> > [<c12210d0>] (usb_hcd_irq+0x0/0x60)
> > Disabling IRQ #16
> > pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > pci 0000:00:02.0: setting latency timer to 64
> > ioremap error for 0xbdce0000-0xbdce3000, requested 0x10, got 0x0
> > [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> > [drm] No driver support for vblank timestamp query.
> > [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> >
> > Is this likely to be related the the irq issues your patch addressed or
> > is it a separate thing that I should report separately?
>
> It's the i915 IRQ alright, but I'm not sure what the cause is. An
> unexpected interrupt arrived, although you don't use any paths in the
> driver that use interrupts, nor should one be generated when all we are
> doing is initialising the device structs. Should just be a minor nuisance
> fortunately.
>

OK, I haven't raised the bug report yet, but I now know how to create it - 
reboot via kexec which is what I must have done when I built and installed the 
kernel to test your patches. I guess not having booted via the bios is leaving 
the card in an odd state. Do you care any more, please? If you do, I'll open 
the bug report. 

> If you can open a bug report to track it and attach
> /sys/kernel/debug/dri/0/i915_gem_interrupts maybe we can work out from
> the interrupt that arrived, why it was triggered.
> -Chris

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
