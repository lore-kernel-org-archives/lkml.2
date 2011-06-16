Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1FPVpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:45:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61591 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab1FPVps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:45:48 -0400
From: Martin <marogge@onlinehome.de>
To: wzab@ise.pw.edu.pl
Subject: Re: Kernel panic on HT machine - maybe i915 related?
Date: Thu, 16 Jun 2011 23:45:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39.1-ck2; KDE/4.5.5; x86_64; ; )
Cc: "vger.kernel.org, " <linux-kernel@vger.kernel.org>
References: <201106152224.34487.marogge@onlinehome.de> <4DF9EBD0.5020403@ise.pw.edu.pl>
In-Reply-To: <4DF9EBD0.5020403@ise.pw.edu.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106162345.16305.marogge@onlinehome.de>
X-Provags-ID: V02:K0:bPhLkQep8QPs9p8qo11jU4+fAM9PSyXsejz7asBo2/s
 AIR8GuWXGWpHKimjJ0YQaa3W72SdIwHP/wWqkxdMhWLgaGpvp6
 QsteKWRxvZ3LHsrCE2lisnuZYeHF1TdFnriIvmy0WrKyZ7crjC
 cJ31jiPpbdRJVtWzFaG5CPtEEM9wJehME9WEllsL4/FgBXlkY3
 1bkVQZju5gessebdAdlCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011 13:41:04 Wojciech Zabołotny wrote:
> W dniu 15.06.2011 22:24, Martin wrote:
> > Same here, although my panics look different from yours. In both cases I
> > had a lot of hardware interrupts on the stack trace but no kmemcheck. I
> > only remembered to take a photo with my mobile phone the second time.
> > The stack trace contains handle_*irq*, tg3, ata_bmdma, __ata_sff, i915,
> > drm_vblank_put, intel_thermal, try_preempt, resched*, drm_vblank_put,
> > do_invalid_op, oops_end, do_bounds, panic. The EIP is
> > drm_vblank_put+0x13/0x50.
> 
> Probably you have not enabled kmemcheck in the kernel configuration?

good point. ;)

> 
> > Could this be an i915 issue with 2.6.39.1? At home I have two other
> > machines on i915 but with different chipsets that run fine with the same
> > kernel.
> 
> The i915 driver with 82865G chipset works strange for quite a long time
> (since 2.6.37???) The machine which causes problem uses this chipset.
> Another one which works good with 2.6.39.1 (I write this message on it)
> uses: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated
> Graphics Controller (rev 03)
> 

I had i915 weirdness with different chipsets at different times. Other than 
the oops happening in drm_vblank_put it occurred to me that a random X 
screensaver must have been active when it happened.

I didn't manage to trigger the panic over night with the problematic kernel in 
runlevel 3 (console), nor did it occur with a vanilla 2.6.39.1 during the day. 
I shall have to continue testing.

Martin
