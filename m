Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab1ELM1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:27:08 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46101 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab1ELM1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o1QagwTPgf2Q6QRT7qxKEMTDMhVU1wx60FWyz4U0mIMLvxPcwgkb9qds5ZcbPUTNvJ
         b1+hdyBBrXRbNMZAd9m6pHnpXYmuL3+C44QGzqT9BR8vMd5TXOgwIGxwDu+fAy8AgssX
         OKVQWpcH9PFxEPNJVI2+rzN1IRdU71oyQb/9E=
Date: Thu, 12 May 2011 20:26:58 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: lock_stat &rq->lock/1 class name meaning
Message-ID: <20110512122658.GB3639@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4DCAB8A2.8060605@linux.com>
 <20110512105756.GA3329@zhy>
 <4DCBCE56.2010607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DCBCE56.2010607@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 02:11:02PM +0200, Juri Lelli wrote:
> Thanks!
> 
> On 05/12/2011 12:57 PM, Yong Zhang wrote:
> >On Wed, May 11, 2011 at 06:26:10PM +0200, Juri Lelli wrote:
> >>Hi,
> >>I'm trying to collect contention statistics through /proc/lock_stat
> >>about scheduler data structures.
> >>
> >>What I obtain if a do "cat /proc/lock_stat" is something like:
> >>...
> >>&rq->lock:         13128          13128           0.43
> >>[...]
> >>
> >>I guess the first one is about the per-rq (per-CPU) spinlock, but
> >>what about the second? What the "/1" stands for?
> >
> >It is also rq but it's subclass is 1.
> >
> >Take a look at raw_spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
> >in _double_lock_balance()
> 
> Ok, I've put more light on this also looking at lockdep.h comments
> and lockdep-design documentation.
> 
> Since I'm probably not the only one having troubles undestanding
> lock_stat output, maybe could be useful to add something on this
> inside lockstat documentation (I can try to do this). What you
> think?

Any improvement will be good :)

Cc'ing PeterZ and Ingo.

Thanks,
Yong
