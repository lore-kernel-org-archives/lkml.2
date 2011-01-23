Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab1AWSwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:52:35 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50653 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1AWSwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:52:35 -0500
Date: Sun, 23 Jan 2011 19:52:33 +0100
From: Andreas Mohr <andi@lisas.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Christian Kujau <christian@nerdbynature.de>,
        Michael Witten <mfwitten@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: 'autogroup' sched code KILLING responsiveness
Message-ID: <20110123185233.GA22378@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110123151556.GA15236@elte.hu>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Christian, Michael, can you confirm that this and the second patch fixes the 
> interactivity bug for you? If yes then i'd like to apply and send this fix to Linus 
> ASAP.
> 
> Thanks,
> 
> 	Ingo

I'm currently running with autogroup enabled for the first time,
on Athlon XP -rc2 with _first patch only_ applied (saw second part too late),
and it appears to be working fine with some stress tests added
(multi-app benchmark, while... true, yes etc.).
Interestingly I had chosen to DISABLE the cgroup part of the scheduler
several months ago since it was slower than non-cgroup by quite some margin.


One should perhaps consider this issue to be evidence of a notable lack
of (possibly automated) test/usage coverage of UP configs
(together with the recent build error on UP that was discovered
once hitting -rc1 only, and not earlier!).


For this particular fix, perhaps the 0 vs. tg->shares change could be
followed up by a WARN_ON_ONCE() in some more internal non-hotpath function
if such a check is feasible in the current case.

Thanks,

Andreas Mohr
