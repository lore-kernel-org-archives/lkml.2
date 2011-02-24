Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab1BXK5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:57:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:43160 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab1BXK5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:57:05 -0500
Subject: Re: [PATCH] mm: optimize replace_page_cache_page
From: Miklos Szeredi <mszeredi@suse.cz>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <AANLkTik47+rots2XsouMiCnefmxeC_n=Q9mwBSyE9YjC@mail.gmail.com>
References: <1297355626-5152-1-git-send-email-minchan.kim@gmail.com>
	 <20110219234121.GA2546@barrios-desktop>
	 <20110223144445.86d0ca2b.akpm@linux-foundation.org>
	 <AANLkTik47+rots2XsouMiCnefmxeC_n=Q9mwBSyE9YjC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 11:56:55 +0100
Message-ID: <1298545015.5637.7.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 08:37 +0900, Minchan Kim wrote:
> On Thu, Feb 24, 2011 at 7:44 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Sun, 20 Feb 2011 08:41:21 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> Resend.
> >
> > Reignore.
> >
> >> he patch is based on mmotm-2011-02-04 +
> >> mm-add-replace_page_cache_page-function-add-freepage-hook.patch.
> >>
> >> On Fri, Feb 11, 2011 at 01:33:46AM +0900, Minchan Kim wrote:
> >> > This patch optmizes replace_page_cache_page.
> >> >
> >> > 1) remove radix_tree_preload
> >> > 2) single radix_tree_lookup_slot and replace radix tree slot
> >> > 3) page accounting optimization if both pages are in same zone.
> >> >
> >> > Cc: Miklos Szeredi <mszeredi@suse.cz>
> >> > Cc: Rik van Riel <riel@redhat.com>
> >> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >> > Cc: Mel Gorman <mel@csn.ul.ie>
> >> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> >> > ---
> >> >  mm/filemap.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++---------
> >> >  1 files changed, 51 insertions(+), 10 deletions(-)
> >> >
> >> > Hi Miklos,
> >> > This patch is totally not tested.
> >> > Could you test this patch?
> >
> > ^^^ Because of this.
> >
> > Is it tested yet?
> >
> 
> Miklos. Could you test this?
> If you are busy, let me know how to test it. I will.
> Thanks.

Grab git version of libfuse and do something like this:

 fuse/example/fusexmp_fh -obig_writes /mnt/fuse/
 dd if=/tmp/random0 of=/mnt/fuse/tmp/random1 bs=1M
 md5sum /tmp/radom0 /tmp/random1

This should exercise the page moving.

I'll review and test the patch when I have some time.

Thanks,
Miklos

