Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136Ab2FGPN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:13:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41772 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761069Ab2FGPNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:13:55 -0400
Date: Thu, 7 Jun 2012 17:13:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rus <rus@sfinxsoft.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.[34].x Reproducable [Firmware bug] message upon warm boot only
Message-ID: <20120607151352.GA8261@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Rus <rus@sfinxsoft.com>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	linux-kernel@vger.kernel.org
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com>
 <20120607142459.GB5053@x1.osrc.amd.com>
 <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 05:51:51PM +0300, Rus wrote:
> .........
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 21
> model		: 1
> model name	: AMD FX(tm)-8150 Eight-Core Processor
> stepping	: 2

Ok, family F15h, as expected.

> >> Is this message harmless or this is some problem with hardware/bios/Linux ?
> >
> > Mostly harmless, fix is already upstream: f227d306cf3 and also on its
> > way to stable. You can try 3.5-rc1 on the box (it should be pretty
> > stable on AMD) or wait for the stable backport.
> 
> Ok, compiling ... will report soon. The reason I've asked - this
> particular brand new box is freezing once at a 2-3 days without any
> output - no oops, no sysrq, nothing. So I'm trying to investigate what
> is the problem. The previous kernels (3.3.x) have the serious problem
> with iommu - the onboard USB3.0 and Ethernet did not work at all on
> them. The 3.4.x is better, but seems like still freezing.

Hmm, that doesn't sound good. What exactly do you do when it freezes,
any repeatable usage patterns? Does the freeze happen if you disable
IOMMU in the BIOS?

Do you have serial console attached to it?

Do you have CONFIG_DETECT_HUNG_TASK enabled? Also CONFIG_PROVE_LOCKING,
CONFIG_KMEMCHECK, CONFIG_DEBUG_PREEMPT. These are just a couple of debug
options to enable right now which could tell us more.

Anything else that I'm forgetting?

Ah, and send me dmesg privately pls, from 3.4 and 3.5-rc1.

That's all I can think of right now.

-- 
Regards/Gruss,
Boris.
