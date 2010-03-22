Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0CVLzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:55:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60357 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0CVLzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:55:10 -0400
Date: Mon, 22 Mar 2010 11:55:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] mm, fs: warn on missing address space operations
Message-ID: <20100322115508.GE30031@ZenIV.linux.org.uk>
References: <20100322053937.GA17637@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322053937.GA17637@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 04:39:37PM +1100, Nick Piggin wrote:
> It's ugly and lazy that we do these default aops in case it has not
> been filled in by the filesystem.
> 
> A NULL operation should always mean either: we don't support the
> operation; we don't require any action; or a bug in the filesystem,
> depending on the context.
> 
> In practice, if we get rid of these fallbacks, it will be clearer
> what operations are used by a given address_space_operations struct,
> reduce branches, reduce #if BLOCK ifdefs, and should allow us to get
> rid of all the buffer_head knowledge from core mm and fs code.
> 
> We could add a patch like this which spits out a recipe for how to fix
> up filesystems and get them all converted quite easily.

Um.  Seeing that part of that is for methods absent in mainline (->release(),
->sync()), I'd say that making it mandatory at that point is a bad idea.

As for the rest...  We have 90 instances of address_space_operations
in the kernel.  Out of those:
	28 have ->releasepage != NULL
	27 have ->set_page_dirty != NULL
	25 have ->invalidatepage != NULL

So I'm not even sure that adding that much boilerplate makes sense.
