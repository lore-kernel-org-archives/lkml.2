Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab1FIHTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:19:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37658 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab1FIHTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:19:08 -0400
Date: Thu, 9 Jun 2011 09:18:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        stable@kernel.org
Subject: Re: [PATCH] oprofile, x86: Fix race in nmi handler while starting
Message-ID: <20110609071854.GE20544@elte.hu>
References: <1307465249-20055-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307465249-20055-1-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> In some rare cases, nmis are generated immediately after the nmi 
> handler of the cpu was started. This causes the counter not to be 
> enabled. Before enabling the nmi handlers we need to set variable 
> ctr_running first and make sure its value is written to memory.
> 
> Also, the patch makes all existing barriers a memory barrier 
> instead of a compiler barrier only.

Could we *PLEASE* just do the obvious and turn oprofile into a perf 
user on x86 too, like ARM already does? Two years down the line and 
there's zero progress in that area. We want to obsolete the Oprofile 
PMU bits on x86, the infrastructure duplication causes non-trivial 
problems like this one.

Thanks,

	Ingo
