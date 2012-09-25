Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2IYQAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:00:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35933 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab2IYQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:00:12 -0400
MIME-Version: 1.0
In-Reply-To: <1348581414-19103-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1348581414-19103-1-git-send-email-n-horiguchi@ah.jp.nec.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 25 Sep 2012 11:59:51 -0400
X-Google-Sender-Auth: Mp-WXq3h6aq1naAt-VwsLKLiErI
Message-ID: <CAHGf_=rbyk1UFGwyQ0BSN3qM_K+5J3Q-Aj=xjNDZFrTrZ6a3dw@mail.gmail.com>
Subject: Re: [PATCH] pagemap: fix wrong KPF_THP on slab pages
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 9:56 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> KPF_THP can be set on non-huge compound pages like slab pages, because
> PageTransCompound only sees PG_head and PG_tail. Obviously this is a bug
> and breaks user space applications which look for thp via /proc/kpageflags.
> Currently thp is constructed only on anonymous pages, so this patch makes
> KPF_THP be set when both of PageAnon and PageTransCompound are true.

Indeed. Please add some comment too.
