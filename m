Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1DQISs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 04:18:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38167 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1DQISj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 04:18:39 -0400
Date: Sun, 17 Apr 2011 10:18:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
Message-ID: <20110417081827.GC29733@elte.hu>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <1302943877.32491.9.camel@twins>
 <20110417081540.GL31407@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110417081540.GL31407@erda.amd.com>
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

> > I'd really prefer not to do this for .39, and I'll have to sit down and 
> > actually read this code. It looks like we went from O(n^2) to O(n!) or 
> > somesuch, also not much of an improvement. I'll have to analyze the solver 
> > to see what it does for 'simple' constraints set to see if it will indeed 
> > be more expensive than the O(n^2) solver we had.
> 
> It wont be more expensive, if there is a solution. But if there is no one we 
> walk all possible ways now which is something like O(n!).

So with 6 counters it would be a loop of 720, with 8 counters a loop of 40320, 
with 10 counters a loop of 3628800 ... O(n!) is not fun.

Thanks,

	Ingo
