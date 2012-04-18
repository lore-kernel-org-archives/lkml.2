Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2DROk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:40:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51227 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808Ab2DROk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:40:56 -0400
Date: Wed, 18 Apr 2012 15:40:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmemleak: do not leak object after tree insertion
 error (v2, fixed)
Message-ID: <20120418144043.GH1505@arm.com>
References: <20120402230656.GA4353@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402230656.GA4353@swordfish>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 12:06:56AM +0100, Sergey Senozhatsky wrote:
> [PATCH] kmemleak: do not leak object after tree insertion error
> 
> In case when tree insertion fails due to already existing object
> error, pointer to allocated object gets lost due to lookup_object()
> overwrite. Free allocated object and return the existing one, 
> obtained from lookup_object().

We really need to return NULL if the tree insertion fails as kmemleak is
disabled in this case (fatal condition for kmemleak). So we could just
call kmem_cache_free(object_cache, object) in the 'if' block.

-- 
Catalin
