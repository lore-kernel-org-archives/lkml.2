Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab0DHULc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:11:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42373 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0DHULb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=B4e38g4Sw1VNTso7qNM9PiB8G2YkZvFJkvcE8/eP4fCFKAlQ5t63NFodv2e9D3y/tZ
         Isb4McJiCZgh58BCZwGR65Ujr3q0GP8RxCQu9RdJxGaVMGqWVojN+VXBzjIco8QS5hnE
         6Owt1lCbQ8RawMdOJoXLFGlEeuDDj2D7s0mpM=
Date: Thu, 8 Apr 2010 22:11:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] perf: Store active software events in a hashlist
Message-ID: <20100408201116.GA6401@nowhere>
References: <1270642150.20295.831.camel@laptop> <1270755554-6618-1-git-send-regression-fweisbec@gmail.com> <1270757081.2458.4.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1270757081.2458.4.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 10:04:41PM +0200, Eric Dumazet wrote:
> Le jeudi 08 avril 2010 à 21:39 +0200, Frederic Weisbecker a écrit :
> 
> ...
> 
> > @@ -5401,6 +5507,16 @@ static void __cpuinit perf_event_init_cpu(int cpu)
> >  	spin_lock(&perf_resource_lock);
> >  	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
> >  	spin_unlock(&perf_resource_lock);
> > +
> > +	mutex_lock(&cpuctx->hlist_mutex);
> > +	if (&cpuctx->hlist_refcount > 0) {
> 
> 
> 	if (cpuctx->hlist_refcount > 0)


Doh! Thanks, will fix.


> 
> > +		struct swevent_hlist *hlist;
> > +
> > +		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
> > +		WARN_ON_ONCE(!hlist);
> > +		rcu_assign_pointer(cpuctx->swevent_hlist, hlist);
> > +	}
> > +	mutex_unlock(&cpuctx->hlist_mutex);
> >  }
> 
> 
> 

