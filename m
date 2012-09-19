Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab2ISSFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:05:42 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35817 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab2ISSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <1348039748-32111-1-git-send-email-minchan@kernel.org>
References: <1348039748-32111-1-git-send-email-minchan@kernel.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 19 Sep 2012 14:05:20 -0400
Message-ID: <CAHGf_=oSSsJEeh7eN+R6P3n0vq2h5+3DPmogpXqDiu1jJyKmpg@mail.gmail.com>
Subject: Re: [PATCH] memory-hotplug: fix zone stat mismatch
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Shaohua Li <shli@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 3:29 AM, Minchan Kim <minchan@kernel.org> wrote:
> During memory-hotplug stress test, I found NR_ISOLATED_[ANON|FILE]
> are increasing so that kernel are hang out.
>
> The cause is that when we do memory-hotadd after memory-remove,
> __zone_pcp_update clear out zone's ZONE_STAT_ITEMS in setup_pageset
> without draining vm_stat_diff of all CPU.
>
> This patch fixes it.

zone_pcp_update() is called from online pages path. but IMHO,
the statistics should be drained offline path. isn't it?

thanks.
