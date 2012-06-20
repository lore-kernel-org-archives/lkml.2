Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2FTFBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:01:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49623 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2FTFBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:01:46 -0400
MIME-Version: 1.0
In-Reply-To: <1339792575-17637-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1339792575-17637-1-git-send-email-kosaki.motohiro@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 20 Jun 2012 01:01:25 -0400
X-Google-Sender-Auth: PM62Frs9p7MHYgj2NclQQmuFVyg
Message-ID: <CAHGf_=qmCdfv0jxOqdrHduTgnjPxgBT7oTdhkywSCCRAKu3A-A@mail.gmail.com>
Subject: Re: [PATCH] mm, fadvise: don't return -EINVAL when filesystem has no
 optimization way
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, Eric Wong <normalperson@yhbt.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 4:36 PM,  <kosaki.motohiro@gmail.com> wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Eric Wong reported his test suite was fail when /tmp is tmpfs.
>
> https://lkml.org/lkml/2012/2/24/479
>
> Current,input check of POSIX_FADV_WILLNEED has two problems.
>
> 1) require a_ops->readpage.
>   But in fact, force_page_cache_readahead() only require
>   a target filesystem has either ->readpage or ->readpages.
> 2) return -EINVAL when filesystem don't have ->readpage.
>   But, posix says, it should be retrieved a hint. Thus fadvise()
>   should return 0 if filesystem has no optimization way.
>   Especially, userland application don't know a filesystem type
>   of TMPDIR directory as Eric pointed out. Then, userland can't
>   avoid this error. We shouldn't encourage to ignore syscall
>   return value.
>
> Thus, this patch change a return value to 0 when filesytem don't
> support readahead.
>
> Cc: linux-mm@kvack.org
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hillf Danton <dhillf@gmail.com>
> Signed-off-by: Eric Wong <normalperson@yhbt.net>
> Tested-by: Eric Wong <normalperson@yhbt.net>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---

no objection?
