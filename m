Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1ACCuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 21:50:05 -0500
Received: from thunk.org ([69.25.196.29]:32961 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1ACCuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 21:50:02 -0500
Date: Sun, 02 Jan 2011 18:48:01 -0500
Message-Id: <E1PZXeb-0004AV-2b@tytso-glaptop>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org
Subject: Should we be using unlikely() around tests of GFP_ZERO?
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Given the patches being busily submitted by trivial patch submitters to
make use kmem_cache_zalloc(), et. al, I believe we should remove the
unlikely() tests around the (gfp_flags & __GFP_ZERO) tests, such as:

-	if (unlikely((flags & __GFP_ZERO) && objp))
+	if ((flags & __GFP_ZERO) && objp)
		memset(objp, 0, obj_size(cachep));

Agreed?  If so, I'll send a patch...

	    					- Ted
