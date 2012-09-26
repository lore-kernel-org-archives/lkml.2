Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2IZAVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:21:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55630 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2IZAUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:20:53 -0400
Date: Tue, 25 Sep 2012 17:20:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pagemap: fix wrong KPF_THP on slab pages
In-Reply-To: <1348592715-31006-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.00.1209251719400.21751@chino.kir.corp.google.com>
References: <1348592715-31006-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012, Naoya Horiguchi wrote:

> KPF_THP can be set on non-huge compound pages like slab pages, because
> PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug
> and breaks user space applications which look for thp via /proc/kpageflags.
> Currently thp is constructed only on anonymous pages, so this patch makes
> KPF_THP be set when both of PageAnon and PageTransCompound are true.
> 
> Changelog in v2:
>   - add a comment in code
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Wouldn't PageTransCompound(page) && !PageHuge(page) && !PageSlab(page) be 
better for a future extension of thp support?
