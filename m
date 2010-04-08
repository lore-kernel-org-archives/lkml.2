Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0DHUEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:04:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40368 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0DHUEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lJ1bambTgyjg82bGAmPON0+vsvunW+9ekEasWjF/Pv14fxSCyrTttCKeAezXd5KdYN
         YOj5oADIjbfrnvCQdQfifuPFiIYTVRS2r0UWBUpl/yOSmjf7tze7edV3LoDAgQeElfAM
         mhh2xJZNlG4R26TycRjcXDzgEqvB6CbrlZfIQ=
Subject: Re: [PATCH v2] perf: Store active software events in a hashlist
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1270755554-6618-1-git-send-regression-fweisbec@gmail.com>
References: <1270642150.20295.831.camel@laptop>
	 <1270755554-6618-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 22:04:41 +0200
Message-ID: <1270757081.2458.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 avril 2010 à 21:39 +0200, Frederic Weisbecker a écrit :

...

> @@ -5401,6 +5507,16 @@ static void __cpuinit perf_event_init_cpu(int cpu)
>  	spin_lock(&perf_resource_lock);
>  	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
>  	spin_unlock(&perf_resource_lock);
> +
> +	mutex_lock(&cpuctx->hlist_mutex);
> +	if (&cpuctx->hlist_refcount > 0) {


	if (cpuctx->hlist_refcount > 0)

> +		struct swevent_hlist *hlist;
> +
> +		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
> +		WARN_ON_ONCE(!hlist);
> +		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
> +	}
> +	mutex_unlock(&cpuctx->hlist_mutex);
>  }



