Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1LLTbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:31:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64179 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1LLTbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:31:43 -0500
Message-ID: <1323718298.2583.21.camel@edumazet-laptop>
Subject: Re: [Slub allocator] There are chances that
 kmem_cache_cpu->freelist gets lost if the process happens to be rescheduled
 to a differenet cpu before the local_irq_save() completes in __slab_alloc()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: zhihua che <zhihua.che@gmail.com>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 12 Dec 2011 20:31:38 +0100
In-Reply-To: <alpine.DEB.2.00.1112121252430.31975@router.home>
References: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>
	  <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	  <alpine.DEB.2.00.1112120922020.28410@router.home>
	 <1323711558.2583.11.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1112121252430.31975@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 12:53 -0600, Christoph Lameter a écrit :
> On Mon, 12 Dec 2011, Eric Dumazet wrote:
> 
> > Indeed, I reproduced the leak with hackbench and lot of threads.
> 
> Ran it here and did not see anything. But obviously this is an issue.
> Strange that no one noticed earlier. Usage of CONFIG_PREEMPT must not be
> that frequent.
> 

Yes, probably :(

All I did was using hackbench with 4000 threads on my 16 cpu machine,

while :; do hackbench 100 process 2000 ; done

I got about one leak (freelist chain, so several objects leaked) per
second.



