Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab2ILBpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:45:00 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43984 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2ILBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:44:59 -0400
Date: Tue, 11 Sep 2012 18:44:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hugh Dickins <hughd@google.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        bhalevy@tonian.com, dhillf@gmail.com
Subject: Re: + mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
 added to -mm tree
In-Reply-To: <alpine.LSU.2.00.1209111110330.2575@eggly.anvils>
Message-ID: <alpine.DEB.2.00.1209111843010.19285@chino.kir.corp.google.com>
References: <20120816200105.C14EA1E0048@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1209111054510.30962@chino.kir.corp.google.com> <alpine.LSU.2.00.1209111110330.2575@eggly.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Hugh Dickins wrote:

> > > This does revert 2.6.27's dfe195fb79e88 ("mm: fix uninitialized variables
> > > for find_vma_prepare callers"), but it looks like gcc 4.3.0 was one of
> > > those releases too eager to shout about uninitialized variables: only
> > > copy_vma() warns with 4.5.1 and 4.7.1, which a BUG on error silences.
> > > 
> > 
> > That trick doesn't work if CONFIG_BUG=n.
> > 
> > mm/mmap.c: In function 'copy_vma':
> > mm/mmap.c:2344: warning: 'prev' may be used uninitialized in this function
> > mm/mmap.c:2345: warning: 'rb_link' may be used uninitialized in this function
> > mm/mmap.c:2345: warning: 'rb_parent' may be used uninitialized in this function
> 
> Hmm, right: not an option I ever choose, and I hadn't given it a thought.
> 
> But do we care?  If this introduced the only such warning, I would care.

It now has the distinction of being the only warning for CONFIG_BUG=n in 
mm/*.

> But that seems to be far from the case - building my usual config without
> CONFIG_BUG gives me 36 warnings, of uninitialized and unused and
> control reaches end of non-void varieties.
> 

What's so special about copy_vma() that we can't fix it all up to use 
uninitialized_var() so this is handled the proper way?  If CONFIG_BUG 
exists, then we should support it, right?
