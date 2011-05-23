Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031065Ab1EWWWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:22:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47582 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378Ab1EWWWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qtanyFNo22cnlenekf2GtvYCcPJX7srDdBQXGT976Kz01ap/sfwdbkolW/w3KZVike
         xflsItWj8Gll7UXM3r+EZl4Vo27YQ0yhUWEz7UvAgDF+UMU2XsIWjeSTKIB4esNqiJDE
         szkE4OEUS/5CCYT7Rwg9SrQXeFT+nuz6A6xLE=
Subject: Re: [GIT PULL] perf fixes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110523221916.GA8033@nowhere>
References: <20110523134125.GA23518@elte.hu>
	 <1306188648.2638.17.camel@edumazet-laptop>  <20110523221916.GA8033@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 00:22:04 +0200
Message-ID: <1306189324.2638.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 mai 2011 à 00:19 +0200, Frederic Weisbecker a écrit :
> On Tue, May 24, 2011 at 12:10:48AM +0200, Eric Dumazet wrote:
> > Le lundi 23 mai 2011 à 15:41 +0200, Ingo Molnar a écrit :
> > > Linus,
> > > 
> > > Please pull the latest perf-urgent-for-linus git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus
> > > 
> > >  Thanks,
> > > 
> > 
> > Hi Ingo
> > 
> > I just tried latest "perf top" from linux-2.6 tree on my 32bit x86 host.
> > 
> > It outputs endless errors, I dont know if you guys already are aware of
> > this ?
> > 
> > Can't parse sample, err = -14
> > Can't parse sample, err = -14
> > Can't parse sample, err = -14
> > Can't parse sample, err = -14
> > Can't parse sample, err = -14
> > Can't parse sample, err = -14
> > Can't parse sample, err = -14
> > Can't parse sample, err = -14
> 
> Hi Eric,
> 
> Does that fix the issue?
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 252b72a..6635fcd 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
>  	int i;
>  
>  	for (i = 0; i < 64; i++) {
> -		if (mask & (1UL << i))
> +		if (mask & (1ULL << i))
>  			size++;
>  	}
>  
> 

It does, thanks Frederic !


