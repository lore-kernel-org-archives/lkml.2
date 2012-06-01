Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2FAGj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 02:39:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55994 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab2FAGjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 02:39:25 -0400
Date: Fri, 1 Jun 2012 09:39:20 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Joonsoo Kim <js1304@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] slub: change cmpxchg_double_slab in get_freelist() to
 __cmpxchg_double_slab
In-Reply-To: <alpine.DEB.2.00.1205311351540.2764@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1206010934460.2163@tux.localdomain>
References: <1336665378-2967-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1205142332060.19403@chino.kir.corp.google.com> <alpine.DEB.2.00.1205311351540.2764@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, David Rientjes wrote:
> > On Fri, 11 May 2012, Joonsoo Kim wrote:
> > 
> > > get_freelist() is only called by __slab_alloc with interrupt disabled,
> > > so __cmpxchg_double_slab is suitable.
> > > 
> > > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> > 
> > Acked-by: David Rientjes <rientjes@google.com>

On Thu, 31 May 2012, David Rientjes wrote:
> Pekka, did you want to pick this up so it can get into linux-next?

We now made get_freelist() *require* interrupts to be disabled which 
deserves a comment, no?

Also, what do we gain from patches like this? It's somewhat 
counterintuitive that we have a function with "cmpxchg" in it which is not 
always atomic (i.e. you need to have interrupts disabled).

IIRC, there was even a long rant about this by Linus but I'm unable to 
find it in my email archives.

			Pekka
