Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab2CDG6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 01:58:10 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50412 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2CDG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 01:58:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of minchan.kim@gmail.com designates 10.68.244.99 as permitted sender) smtp.mail=minchan.kim@gmail.com; dkim=pass header.i=minchan.kim@gmail.com
Date: Sun, 4 Mar 2012 15:57:59 +0900
From: Minchan Kim <minchan@kernel.org>
To: Satoru Moriya <satoru.moriya@hds.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "shaohua.li@intel.com" <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
Message-ID: <20120304065759.GA7824@barrios>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satoru,

On Fri, Mar 02, 2012 at 12:36:40PM -0500, Satoru Moriya wrote:
> Sometimes we'd like to avoid swapping out anonymous memory
> in particular, avoid swapping out pages of important process or
> process groups while there is a reasonable amount of pagecache
> on RAM so that we can satisfy our customers' requirements.
> 
> OTOH, we can control how aggressive the kernel will swap memory pages
> with /proc/sys/vm/swappiness for global and
> /sys/fs/cgroup/memory/memory.swappiness for each memcg.
> 
> But with current reclaim implementation, the kernel may swap out
> even if we set swappiness==0 and there is pagecache on RAM.
> 
> This patch changes the behavior with swappiness==0. If we set
> swappiness==0, the kernel does not swap out completely
> (for global reclaim until the amount of free pages and filebacked
> pages in a zone has been reduced to something very very small
> (nr_free + nr_filebacked < high watermark)).
> 
> Any comments are welcome.
> 
> Regards,
> Satoru Moriya
> 
> Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>

Acked-by: Minchan Kim <minchan@kernel.org>

I agree this feature but current code is rather ugly on readbility.
It's not your fault because it is caused by adding 'noswap' to avoid
scanning of anon pages when priority is 0. You just used that code. :)

Hillf's version looks to be much clean refactoring so after we merge
your patch, we can tidy it up with Hillf's patch.

