Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030431Ab2HWU5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:57:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030270Ab2HWU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:56:59 -0400
Date: Fri, 24 Aug 2012 05:56:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] revert changes to zcache_do_preload()
Message-ID: <20120823205648.GA2066@barrios>
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Thu, Aug 23, 2012 at 10:33:09AM -0500, Seth Jennings wrote:
> This patchset fixes a regression in 3.6 by reverting two dependent
> commits that made changes to zcache_do_preload().
> 
> The commits undermine an assumption made by tmem_put() in
> the cleancache path that preemption is disabled.  This change
> introduces a race condition that can result in the wrong page
> being returned by tmem_get(), causing assorted errors (segfaults,
> apparent file corruption, etc) in userspace.
> 
> The corruption was discussed in this thread:
> https://lkml.org/lkml/2012/8/17/494

I think changelog isn't enough to explain what's the race.
Could you write it down in detail?

And you should Cc'ed Xiao who is author of reverted patch.

> 
> Please apply this patchset to 3.6.  This problem didn't exist
> in previous releases so nothing need be done for the stable trees.
> 
> Seth Jennings (2):
>   Revert "staging: zcache: cleanup zcache_do_preload and
>     zcache_put_page"
>   Revert "staging: zcache: optimize zcache_do_preload"
> 
>  drivers/staging/zcache/zcache-main.c |   54 +++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 23 deletions(-)
> 
> -- 
> 1.7.9.5
> 
