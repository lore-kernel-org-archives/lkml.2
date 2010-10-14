Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0JNHXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:23:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21022 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JNHXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=TBK97tf2Prn5LEO+wvpx88TggQpSGVjp4DSU+JFjnc4JhHWYToIBoaov6qztwt76C9
         XW8zrzBSaeiInv2nSZXg==
Date: Thu, 14 Oct 2010 00:23:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH net-next] net:  allocate skbs on local node
In-Reply-To: <4CB6A1AB.4030800@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1010140018130.5392@chino.kir.corp.google.com>
References: <1286838210.30423.128.camel@edumazet-laptop> <1286839363.30423.130.camel@edumazet-laptop> <1286859925.30423.184.camel@edumazet-laptop> <20101011230322.f0f6dd47.akpm@linux-foundation.org> <1286866699.30423.234.camel@edumazet-laptop>
 <20101012002435.f51f2c0e.akpm@linux-foundation.org> <1286869793.2732.24.camel@edumazet-laptop> <20101012005856.994bea6d.akpm@linux-foundation.org> <4CB441CB.2000708@cs.helsinki.fi> <alpine.DEB.2.00.1010120745360.31832@router.home>
 <alpine.DEB.2.00.1010121234380.10165@chino.kir.corp.google.com> <alpine.DEB.2.00.1010131056180.29099@router.home> <alpine.DEB.2.00.1010131342310.15185@chino.kir.corp.google.com> <alpine.DEB.2.00.1010131642220.8351@router.home>
 <alpine.DEB.2.00.1010131539440.27839@chino.kir.corp.google.com> <4CB6A1AB.4030800@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Pekka Enberg wrote:

> Argh. Why would we want to introduce something that's effectively a new
> allocator based on SLUB? If there's something controversial in the current
> patch series, lets just keep it out of mainline. A "rewrite" is the reason
> we're in this mess so lets not repeat the same mistake again!
> 

SLUB is a good base framework for developing just about any slab allocator 
you can imagine, in part because of its enhanced debugging facilities.  
Nick originally developed SLQB with much of the same SLUB framework and 
the queueing changes that Christoph is proposing in his new unified 
allocator builds upon SLUB.

Instead of the slab.c, slab_queue.c, and slab_nonqueue.c trifecta, I 
suggested building as much of the core allocator into a single file as 
possible and then extending that with a config option such as 
CONFIG_SLAB_QUEUEING, if possible.  Christoph knows his allocator better 
than anybody so he'd be the person to ask if this was indeed feasible and, 
if so, I think it's in the best interest of a long-term maintainable 
kernel.

I care about how this is organized because I think the current config 
option demanding users select between SLAB and SLUB without really 
understanding the differences (especially for users who run a very wide 
range of applications and the pros and cons of better microbenchmark 
results for one allocator over another isn't at all convincing) is 
detrimental.
