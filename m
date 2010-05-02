Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0EBR27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 13:28:59 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:60859 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab0EBR26 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 13:28:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LLF3iP5iCx6OgnOmiyVoeiiwq9xYwoU1eSGdJKkiqySlkTnLirsL5NgiZfGkTFXSrB
         qGfx7LVipzjfQbmQpPO450yW4gm7sk4K52Q/mZ0Tu1+nuvlIcyuAbfIkV/P0uqGs8Sx+
         cw7MUZS5Y/zdq/waAwzuLQv8jXF01kXaUPUEQ=
MIME-Version: 1.0
In-Reply-To: <1272529930-29505-2-git-send-email-mel@csn.ul.ie>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie>
	 <1272529930-29505-2-git-send-email-mel@csn.ul.ie>
Date: Mon, 3 May 2010 02:28:56 +0900
Message-ID: <k2z28c262361005021028w31775ebah7c27411bb411b9f8@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 5:32 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> Take all the locks for all the anon_vmas in anon_vma_lock, this properly
> excludes migration and the transparent hugepage code from VMA changes done
> by mmap/munmap/mprotect/expand_stack/etc...
>
> Unfortunately, this requires adding a new lock (mm->anon_vma_chain_lock),
> otherwise we have an unavoidable lock ordering conflict.  This changes the
> locking rules for the "same_vma" list to be either mm->mmap_sem for write,
> or mm->mmap_sem for read plus the new mm->anon_vma_chain lock.  This limits
> the place where the new lock is taken to 2 locations - anon_vma_prepare and
> expand_downwards.
>
> Document the locking rules for the same_vma list in the anon_vma_chain and
> remove the anon_vma_lock call from expand_upwards, which does not need it.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I like this one.

Although it try to lock the number of anon_vmas attached to a VMA ,
it's small so latency couldn't be big. :)
It's height problem not width problem of tree. :)

Thanks, Rik.
-- 
Kind regards,
Minchan Kim
