Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0LTB7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:59:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49509 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0LTB7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:59:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Dec 2010 10:53:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [RFC 1/5] drop page reference on remove_from_page_cache
Message-Id: <20101220105322.3b0dba88.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4bd059fc4f45fba7ed29a9f4325deb4f437d39f3.1292604745.git.minchan.kim@gmail.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<4bd059fc4f45fba7ed29a9f4325deb4f437d39f3.1292604745.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 02:13:36 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Now we add page reference on add_to_page_cache but doesn't drop it
> in remove_from_page_cache. Such asymmetric makes confusing about
> page reference so that caller should notice it and comment why they
> release page reference. It's not good API.
> 
> Long time ago, Hugh tried it[1] but gave up of reason which
> reiser4's drop_page had to unlock the page between removing it from
> page cache and doing the page_cache_release. But now the situation is
> changed. I think at least things in current mainline doesn't have any
> obstacles. The problem is fs or somethings out of mainline.
> If it has done such thing like reiser4, this patch could be a problem.
> 
> Do anyone know the such things? Do we care about things out of mainline?
> 
> Note :
> The comment of remove_from_page_cache make by copy & paste & s/swap/page/
> from delete_from_swap_cache.
> 
> [1] http://lkml.org/lkml/2004/10/24/140
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: linux-mm@kvack.org
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>

I like this.
Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

