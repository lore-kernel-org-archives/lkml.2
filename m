Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab1GMXLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:11:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab1GMXLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:11:24 -0400
Date: Wed, 13 Jul 2011 16:11:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/12] mm: let swap use exceptional entries
Message-Id: <20110713161121.17fd98a4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1107121501100.2112@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
	<alpine.LSU.2.00.1106140342330.29206@sister.anvils>
	<20110618145254.1b333344.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1107121501100.2112@sister.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 15:08:58 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> > All the crap^Wnice changes made to filemap.c really need some comments,
> > please.  Particularly when they're keyed off the bland-sounding
> > "radix_tree_exception()".  Apparently they have something to do with
> > swap, but how is the poor reader to know this?
> 
> The naming was intentionally bland, because other filesystems might
> in future have other uses for such exceptional entries.
> 
> (I think the field size would generally defeat it, but you can,
> for example, imagine a small filesystem wanting to save sector number
> there when a page is evicted.)
> 
> But let's go bland when it's more familiar, and such uses materialize -
> particularly since I only placed those checks in places where they're
> needed now for shmem/tmpfs/swap.
> 
> I'll keep the bland naming, if that's okay, but send a patch adding
> a line of comment in such places.  Mentioning shmem, tmpfs, swap.

A better fix would be to create a nicely-documented filemap-specific
function with a non-bland name which simply wraps
radix_tree_exception().
