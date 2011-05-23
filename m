Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030720Ab1EWWT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:19:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37634 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934318Ab1EWWT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=HH9IoSqpwqBSbZEv8PclIvL4naA9279uqiodl3P/tGYDBWezhQyp+mRMon+u6E1hnG
         XYkvoOweZRRz+JOFtTf2sS73v3SGQV8BdiqQWD4FAtgvTwluMcZFhsarGUrAmKCqb/sb
         NAwvOCyrVX9qC3d9E6tIKK4P5I2xnN6O/Pgu0=
Date: Tue, 24 May 2011 00:19:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20110523221916.GA8033@nowhere>
References: <20110523134125.GA23518@elte.hu>
 <1306188648.2638.17.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306188648.2638.17.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:10:48AM +0200, Eric Dumazet wrote:
> Le lundi 23 mai 2011 à 15:41 +0200, Ingo Molnar a écrit :
> > Linus,
> > 
> > Please pull the latest perf-urgent-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus
> > 
> >  Thanks,
> > 
> 
> Hi Ingo
> 
> I just tried latest "perf top" from linux-2.6 tree on my 32bit x86 host.
> 
> It outputs endless errors, I dont know if you guys already are aware of
> this ?
> 
> Can't parse sample, err = -14
> Can't parse sample, err = -14
> Can't parse sample, err = -14
> Can't parse sample, err = -14
> Can't parse sample, err = -14
> Can't parse sample, err = -14
> Can't parse sample, err = -14
> Can't parse sample, err = -14

Hi Eric,

Does that fix the issue?

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 252b72a..6635fcd 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
 	int i;
 
 	for (i = 0; i < 64; i++) {
-		if (mask & (1UL << i))
+		if (mask & (1ULL << i))
 			size++;
 	}
 

