Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1ACRXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:23:50 -0500
Received: from waste.org ([173.11.57.241]:40917 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab1ACRXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:23:49 -0500
Subject: Re: Should we be using unlikely() around tests of GFP_ZERO?
From: Matt Mackall <mpm@selenic.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <E1PZXeb-0004AV-2b@tytso-glaptop>
References: <E1PZXeb-0004AV-2b@tytso-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 11:23:46 -0600
Message-ID: <1294075426.3109.99.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-02 at 18:48 -0500, Theodore Ts'o wrote:
> Given the patches being busily submitted by trivial patch submitters to
> make use kmem_cache_zalloc(), et. al, I believe we should remove the
> unlikely() tests around the (gfp_flags & __GFP_ZERO) tests, such as:
> 
> -	if (unlikely((flags & __GFP_ZERO) && objp))
> +	if ((flags & __GFP_ZERO) && objp)
> 		memset(objp, 0, obj_size(cachep));
> 
> Agreed?  If so, I'll send a patch...

Sounds good to me.

We might consider dropping this flag and making the decision statically
(ie alloc vs zalloc), at least for slab objects.

-- 
Mathematics is the supreme nostalgia of our time.


