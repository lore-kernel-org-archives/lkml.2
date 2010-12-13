Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab0LMSGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:06:00 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:34040 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab0LMSF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v3/2ke4P092XS2uyfFpdYoKHm4519Hszn/VkLl+jz9O4dWYGKJ4xAMPtRuIMTcjYra
         ZhV1A7djjOC1qv+jYoArQ4FLecDUWlz37LTnQVhx56F3Ucd0E/SUy6Mrhk2xnzxvDZZa
         FZcaWwOzm+pIzVy1KlIQeSpUP9pErs0grDAOM=
Date: Mon, 13 Dec 2010 19:05:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
Message-ID: <20101213180548.GF1691@nowhere>
References: <20101213155451.GA1691@nowhere>
 <20101213164854.GL5407@ghostprotocols.net>
 <20101213170923.GB1691@nowhere>
 <1292260289.6803.297.camel@twins>
 <20101213171537.GC1691@nowhere>
 <1292260699.6803.305.camel@twins>
 <20101213172216.GB7417@ghostprotocols.net>
 <1292261716.6803.332.camel@twins>
 <20101213174330.GC7417@ghostprotocols.net>
 <1292262673.6803.359.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292262673.6803.359.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 06:51:13PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-13 at 15:43 -0200, Arnaldo Carvalho de Melo wrote:
> > Whatever, never introduced one, they are inserted, IIRC, in the
> > beggining of the stream, so I guess we can just do that sed and call
> > them headers and be done with it. 
> 
> There's the flush thing from Frederic, that's all over the place.
> 
> The easiest way to kill that is to go to separate data files now.
> writing to different files is better for contention anyway, we can grow
> a flusher-thread per buffer and let them write to their own file.

Right. We need to go there in the end anyway.
I had an old experiment of this some month ago:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/percpu

There is one writer per cpu and a (stupid) multiplexing at report time.
It was working. Just the sorting on report time was (stupidly) slow.

I should perhaps rebase that branch and try to make something with it.
