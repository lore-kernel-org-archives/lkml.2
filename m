Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab1EUKda (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:33:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab1EUKd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:33:26 -0400
Date: Sat, 21 May 2011 12:33:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net
Subject: Re: [PATCH 2/2] dont commify big numbers by default, let -B do it
Message-ID: <20110521103315.GA23651@elte.hu>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-3-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305968203-14240-3-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jim Cromie <jim.cromie@gmail.com> wrote:

> Currently, big numbers get commas by default, which complicates parsing
> by automation. [...]

Well, automation can turn it off via --no-big-num, right?

Also, i think for automation we'd also like to have a 'simple output' mode, 
would you like to add that?

Something a bit like what you can see in 'perf stat -v true':

 $ perf stat -v --no-big-num true
 task-clock: 164545 164545 164545
 context-switches: 0 164545 164545
 CPU-migrations: 0 164545 164545
 page-faults: 83 164545 164545
 cycles: 518743 169550 169550
 stalled-cycles-frontend: 326178 169550 169550
 stalled-cycles-backend: 269753 169550 169550
 instructions: 326864 169550 169550
 branches: 67886 169550 169550
 branch-misses: 3874 169550 169550

Without the human output later on, and with elapsed time added as well.

Thanks,

	Ingo
