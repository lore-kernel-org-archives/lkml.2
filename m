Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2IKR4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:56:04 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63115 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab2IKR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:56:02 -0400
Date: Tue, 11 Sep 2012 10:55:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, hughd@google.com, bhalevy@tonian.com,
        dhillf@gmail.com
Subject: Re: + mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
 added to -mm tree
In-Reply-To: <20120816200105.C14EA1E0048@wpzn4.hot.corp.google.com>
Message-ID: <alpine.DEB.2.00.1209111054510.30962@chino.kir.corp.google.com>
References: <20120816200105.C14EA1E0048@wpzn4.hot.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, akpm@linux-foundation.org wrote:

> 
> The patch titled
>      Subject: mm/mmap.c: replace find_vma_prepare() with clearer find_vma_links()
> has been added to the -mm tree.  Its filename is
>      mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Hugh Dickins <hughd@google.com>
> Subject: mm/mmap.c: replace find_vma_prepare() with clearer find_vma_links()
> 
> People get confused by find_vma_prepare(), because it doesn't care about
> what it returns in its output args, when its callers won't be interested.
> 
> Clarify by passing in end-of-range address too, and returning failure if
> any existing vma overlaps the new range: instead of returning an ambiguous
> vma which most callers then must check.  find_vma_links() is a clearer
> name.
> 
> This does revert 2.6.27's dfe195fb79e88 ("mm: fix uninitialized variables
> for find_vma_prepare callers"), but it looks like gcc 4.3.0 was one of
> those releases too eager to shout about uninitialized variables: only
> copy_vma() warns with 4.5.1 and 4.7.1, which a BUG on error silences.
> 

That trick doesn't work if CONFIG_BUG=n.

mm/mmap.c: In function 'copy_vma':
mm/mmap.c:2344: warning: 'prev' may be used uninitialized in this function
mm/mmap.c:2345: warning: 'rb_link' may be used uninitialized in this function
mm/mmap.c:2345: warning: 'rb_parent' may be used uninitialized in this function
