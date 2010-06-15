Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0FOJfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:35:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab0FOJff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:35:35 -0400
Message-ID: <4C1748D6.1020007@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 17:33:10 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: excluding "." and ".." directories when calculating
 tids.
References: <4C1740B1.9070806@cn.fujitsu.com>
In-Reply-To: <4C1740B1.9070806@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng wrote:
> excluding "." and ".." directories when calculating tids.

Please ignore this one, will post an updated version.

Thanks,
Gui

> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  tools/perf/util/thread.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index 1f7ecd4..4f71d1c 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -17,6 +17,8 @@ int find_all_tid(int pid, pid_t ** all_tid)
>  
>  	sprintf(name, "/proc/%d/task", pid);
>  	items = scandir(name, &namelist, NULL, NULL);
> +	/* Excluding "." and ".." directories! */
> +	items -= 2;
>  	if (items <= 0)
>                  return -ENOENT;
>  	*all_tid = malloc(sizeof(pid_t) * items);
