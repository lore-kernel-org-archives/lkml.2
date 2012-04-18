Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2DRPaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:30:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47739 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2DRPaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:30:05 -0400
Date: Wed, 18 Apr 2012 18:29:48 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmemleak: do not leak object after tree insertion error
 (v2, fixed)
Message-ID: <20120418152947.GA8794@swordfish.minsk.epam.com>
References: <20120402230656.GA4353@swordfish>
 <20120418144043.GH1505@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418144043.GH1505@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (04/18/12 15:40), Catalin Marinas wrote:
> On Tue, Apr 03, 2012 at 12:06:56AM +0100, Sergey Senozhatsky wrote:
> > [PATCH] kmemleak: do not leak object after tree insertion error
> > 
> > In case when tree insertion fails due to already existing object
> > error, pointer to allocated object gets lost due to lookup_object()
> > overwrite. Free allocated object and return the existing one, 
> > obtained from lookup_object().
> 
> We really need to return NULL if the tree insertion fails as kmemleak is
> disabled in this case (fatal condition for kmemleak). So we could just
> call kmem_cache_free(object_cache, object) in the 'if' block.
> 

Good point. Thanks a lot for your review!
I was chasing two bugs and sort of messed things up. I'll send v3 shortly.


	Sergey
