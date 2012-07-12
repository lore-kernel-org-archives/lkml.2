Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2GLHNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 03:13:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34121 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab2GLHNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 03:13:48 -0400
Date: Thu, 12 Jul 2012 10:13:39 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Christoph Lameter <cl@linux.com>
cc: Christoph Lameter <christoph@linuxfoundation.org>,
        "wfg@linux.intel.com" <wfg@linux.intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Early crashed kernel on CONFIG_SLOB
In-Reply-To: <alpine.DEB.2.00.1207101830480.5988@router.home>
Message-ID: <alpine.LFD.2.02.1207121013320.2515@tux.localdomain>
References: <20120710111756.GA11351@localhost> <CF1C132D-2873-408A-BCC9-B9F57BE6EDDB@linuxfoundation.org> <alpine.DEB.2.00.1207101830480.5988@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Christoph Lameter wrote:
> Here is the patch:
> 
> Subject: slob: Undo slob hunk
> 
> Commit fd3142a59af2012a7c5dc72ec97a4935ff1c5fc6 broke
> slob since a piece of a change for a later patch slipped into
> it.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  mm/slob.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/slob.c
> ===================================================================
> --- linux-2.6.orig/mm/slob.c	2012-07-06 08:38:18.851205889 -0500
> +++ linux-2.6/mm/slob.c	2012-07-06 08:38:47.259205237 -0500
> @@ -516,7 +516,7 @@ struct kmem_cache *kmem_cache_create(con
> 
>  	if (c) {
>  		c->name = name;
> -		c->size = c->object_size;
> +		c->size = size;
>  		if (flags & SLAB_DESTROY_BY_RCU) {
>  			/* leave room for rcu footer at the end of object */
>  			c->size += sizeof(struct slob_rcu);
> 

Applied, thanks!
