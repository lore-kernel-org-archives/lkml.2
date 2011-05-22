Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1EVXq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 19:46:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755042Ab1EVXq4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 19:46:56 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1105221518180.17400@sister.anvils>
References: <alpine.LSU.2.00.1105221518180.17400@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 22 May 2011 16:46:34 -0700
Message-ID: <BANLkTimpi2vhx3NzR71G640HXXn-keCoqQ@mail.gmail.com>
Subject: Re: Adding an ugliness in __read_cache_page()?
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 3:25 PM, Hugh Dickins <hughd@google.com> wrote:
>
> But drivers/gpu/drm i915 and ttm are using read_cache_page_gfp() or
> read_mapping_page() on tmpfs: on objects created by shmem_file_setup().
>
> Nothing else uses read_cache_page_gfp().  I cannot find anything else
> using read_mapping_page() on tmpfs, but wonder if something might be
> out there.  Stacked filesystems appear not to go that way nowadays.
>
> Would it be better to make i915 and ttm call shmem_read_cache_page()
> directly?  Perhaps removing the then unused read_cache_page_gfp(), or
> perhaps not: may still be needed for i915 and ttm on tiny !SHMEM ramfs.

I would certainly prefer the "make i915 and ttm call
shmem_read_cache_page directly" approach over putting some nasty hack
in __read_cache_page.

                         Linus
