Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0LOQD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:03:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34540 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0LOQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:03:55 -0500
Date: Wed, 15 Dec 2010 16:03:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH v5 5/5] msm: add SMP support for msm
Message-ID: <20101215160323.GA9937@n2100.arm.linux.org.uk>
References: <1292302233-16194-1-git-send-email-johlstei@codeaurora.org> <1292302233-16194-6-git-send-email-johlstei@codeaurora.org> <AANLkTimnuTcv+5cWNzvV-Z=1LHsAmTojDSBJMjjOs7K+@mail.gmail.com> <20101215134414.GA8682@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101215134414.GA8682@huya.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 05:44:14AM -0800, David Brown wrote:
> On Wed, Dec 15, 2010 at 12:35:18PM +0000, Catalin Marinas wrote:
> > On 14 December 2010 04:50, Jeff Ohlstein <johlstei@codeaurora.org> wrote:
> > > +       outer_clean_range(__pa(&pen_release), __pa(&pen_release + 1));
> > > +       __asm__("sev");
> > > +       dsb();
> > 
> > What's the need for the dsb() here (one before SEV maybe)?
> > 
> > Also, do we need to add a "memory" clobber to the SEV asm, not sure
> > whether the compiler would try to reorder the code.
> 
> It doesn't seem to, but it seems to me that it would be allowed to,
> so, I would think the "memory" clobber should be there.

For each difference in the SMP and hotplug code from Realview (if it's
mostly identical to Realview), I'd personally like to see explainations
why it's necessary, either as comments in the code or at the very least
in the commit log.

As far as hotplug code goes, I wish folk would see what their hardware
can actually do with the secondary CPUs - can they take the CPU fully
offline and into a proper dormant state, and when they reawaken it, can
they wake it in the same manner as the CPU is brought online during
boot.

Realview doesn't do this because it can't reset the secondary CPUs
independent of the boot CPU, so the pattern it gives you should not
be followed unless your hardware is similarly restricted.
