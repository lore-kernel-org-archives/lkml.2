Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2DWG5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:57:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60025 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2DWG5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:57:46 -0400
Message-ID: <4F94FD66.2050707@gmail.com>
Date: Mon, 23 Apr 2012 08:57:42 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Dario Faggioli <raistlin@linux.it>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DLS: cleanup clearing overload
References: <CAJd=RBA0Qymw3dadvv5WntVNOr22rn7XPYe0SivY9F+SH1gofw@mail.gmail.com>
In-Reply-To: <CAJd=RBA0Qymw3dadvv5WntVNOr22rn7XPYe0SivY9F+SH1gofw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 01:33 PM, Hillf Danton wrote:
> We have to info puller that there is no more diet, even if CPU goes off.
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>
> ---
>
> --- a/kernel/sched_dl.c	Sat Apr  7 15:00:28 2012
> +++ b/kernel/sched_dl.c	Sun Apr  8 19:24:30 2012
> @@ -83,9 +83,6 @@ static inline void dl_set_overload(struc
>
>   static inline void dl_clear_overload(struct rq *rq)
>   {
> -	if (!rq->online)
> -		return;
> -

This check should have been inserted in -rt with this:
http://lists-archives.com/linux-kernel/15208730-sched-fix-cpupri-hotplug-support.html
As stated in the changlog, it was inserted to resolve a
bug related to hotplug. Most probably the same problem
would affect us, so I would not remove that check.

Thanks,

- Juri
