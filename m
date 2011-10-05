Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934366Ab1JEKgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:36:32 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:40994 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933571Ab1JEKgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:36:31 -0400
Date: Wed, 5 Oct 2011 12:35:45 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
Message-ID: <20111005103545.GQ14063@ics.muni.cz>
References: <20110722081903.GB7561@ics.muni.cz>
 <4E2A7806.1060601@ce.jp.nec.com>
 <20110724221619.GM16487@ics.muni.cz>
 <4E367256.8020206@ct.jp.nec.com>
 <20110908132756.GT31717@ics.muni.cz>
 <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com>
 <20110916140839.GE7428@ics.muni.cz>
 <4E76D810.6010504@ce.jp.nec.com>
 <20110929205748.GX19004@ics.muni.cz>
 <4E8C11B0.30000@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E8C11B0.30000@ce.jp.nec.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.17.147
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 05 Oct 2011 12:36:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 05:13:36PM +0900, Jun'ichi Nomura wrote:
> > yes, 3GB/s and only kwapd0 and kswapd1 is running, no kworker or ksoftirqd..
> 
> Hmm.. did you find any difference in your profile this time?

not sure what do you mean.

> I'm trying to reproduce it myself but no success so far
> (perhaps disks are not fast enough to saturate CPU on my test machine).

hmm, I have 80 SAS 2.0 disks and two E5640 @ 2.67GHz cpus. 
 
> As ksoftirqd in top implies your CPU4 gets too much I/O completions,
> 'rq_affnity = 2' for both dm and SCSI devices might be a solution.
> It'll distribute block completion softirqs to submitters and possibly
> reduce the loads of the 1st CPU in the socket.
> (See the commit below. It's a new feature of 3.1. Not available in 3.0...)

So what next? Should I try 3.1 kernel with this patch applied?

-- 
Luká¹ Hejtmánek
