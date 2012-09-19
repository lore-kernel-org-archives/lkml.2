Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab2ISURt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:17:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2ISURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:17:47 -0400
Date: Thu, 20 Sep 2012 05:17:38 +0900
From: Minchan Kim <minchan@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Shaohua Li <shli@fusionio.com>
Subject: Re: [PATCH] memory-hotplug: fix zone stat mismatch
Message-ID: <20120919201738.GA2425@barrios>
References: <1348039748-32111-1-git-send-email-minchan@kernel.org>
 <CAHGf_=oSSsJEeh7eN+R6P3n0vq2h5+3DPmogpXqDiu1jJyKmpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHGf_=oSSsJEeh7eN+R6P3n0vq2h5+3DPmogpXqDiu1jJyKmpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Wed, Sep 19, 2012 at 02:05:20PM -0400, KOSAKI Motohiro wrote:
> On Wed, Sep 19, 2012 at 3:29 AM, Minchan Kim <minchan@kernel.org> wrote:
> > During memory-hotplug stress test, I found NR_ISOLATED_[ANON|FILE]
> > are increasing so that kernel are hang out.
> >
> > The cause is that when we do memory-hotadd after memory-remove,
> > __zone_pcp_update clear out zone's ZONE_STAT_ITEMS in setup_pageset
> > without draining vm_stat_diff of all CPU.
> >
> > This patch fixes it.
> 
> zone_pcp_update() is called from online pages path. but IMHO,
> the statistics should be drained offline path. isn't it?

It isn't necessary because statistics is right until we reset it to zero
in online path.
Do you have something on your mind that we have to drain it in offline path?

> 
> thanks.

-- 
Kind Regards,
Minchan Kim
