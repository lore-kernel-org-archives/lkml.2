Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1LMUMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:12:14 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38271 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755646Ab1LMUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:12:05 -0500
Date: Tue, 13 Dec 2011 22:11:58 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, zhihua che <zhihua.che@gmail.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Slub allocator] There are chances that kmem_cache_cpu->freelist
 gets lost if the process happens to be rescheduled to a differenet cpu before
 the local_irq_save() completes in __slab_alloc()
In-Reply-To: <alpine.DEB.2.00.1112131025370.23111@router.home>
Message-ID: <alpine.LFD.2.02.1112132211350.1675@tux.localdomain>
References: <CABexPfFR1n=_JdCYLDRcVsPRcqt5FGmhSjoeZP8CLBMRO_CxfA@mail.gmail.com>  <1323702586.1765.14.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <alpine.DEB.2.00.1112120922020.28410@router.home>  <1323711558.2583.11.camel@edumazet-laptop>
 <1323748626.2583.41.camel@edumazet-laptop> <alpine.DEB.2.00.1112131025370.23111@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Eric Dumazet wrote:
>> We can be interrupted and the IRQ handler can free an object an populate
>> freelist too. So the check must always be done.

On Tue, 13 Dec 2011, Christoph Lameter wrote:
> True. So a small memory leak that remained undetected. Hmm.... Wonder how
> one can create some diagnostics to allow detection of this in the future.
>
> Acked-by: Christoph Lameter <cl@linux.com>

I queued this for 3.3. Thanks guys!

 			Pekka
