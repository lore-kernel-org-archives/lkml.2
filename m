Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967834Ab2ERJbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:31:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42542 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2ERJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:31:42 -0400
Date: Fri, 18 May 2012 12:31:37 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1,2/4 v2] slub: use __cmpxchg_double_slab() at interrupt
 disabled place
In-Reply-To: <alpine.DEB.2.00.1205171149050.8534@router.home>
Message-ID: <alpine.LFD.2.02.1205181231170.3899@tux.localdomain>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com> <1337272864-5090-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1205171149050.8534@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012, Christoph Lameter wrote:

> On Fri, 18 May 2012, Joonsoo Kim wrote:
> 
> > get_freelist() is only called by __slab_alloc() with interrupt disabled,
> > so __cmpxchg_double_slab() is suitable.
> >
> > unfreeze_partials() is only called with interrupt disabled,
> > so __cmpxchg_double_slab() is suitable.
> 
> Combine these sentences as well.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

You should add a comment on top of get_freelist() and unfreeze_partials() 
that they now *require* interrupts to be disabled.
