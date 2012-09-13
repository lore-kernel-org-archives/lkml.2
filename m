Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2IMHtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:49:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43121 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2IMHtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
References: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
Date: Thu, 13 Sep 2012 13:19:48 +0530
Message-ID: <CAK9yfHwceAmikpPCYGCnDwzY9igvwkOj7j314+sC4_kD8Egzmg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2012 13:14, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> After merging the akpm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/thermal/cpu_cooling.c: In function 'get_idr':
> drivers/thermal/cpu_cooling.c:89:14: error: 'MAX_ID_MASK' undeclared (first use in this function)
>
> Caused by commit "idr: rename MAX_LEVEL to MAX_IDR_LEVEL" from the akpm
> tree interacting with commit 78edc7cdcf5e ("thermal: add generic cpufreq
> cooling implementation") from the thermal tree.
>
> I have applied the following merge fix patch and can carry it as
> necessary.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 13 Sep 2012 17:42:11 +1000
> Subject: [PATCH] thermal: fix up for MAX_ID_MASK rename
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/thermal/cpu_cooling.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index 99a5d75..f6ce617 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -9,7 +9,7 @@
>   *  it under the terms of the GNU General Public License as published by
>   *  the Free Software Foundation; version 2 of the License.
>   *
> - *  This program is distributed in the hope that it will be useful, but
> + *  This program is distributed in the hope that it will be useful, butX_ID_MASK

                            ^^^^^^^^^^^^^
Looks like a stray paste..


>   *  WITHOUT ANY WARRANTY; without even the implied warranty of
>   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>   *  General Public License for more details.
> @@ -86,7 +86,7 @@ again:
>         else if (unlikely(err))
>                 return err;
>
> -       *id = *id & MAX_ID_MASK;
> +       *id = *id & MAX_IDR_MASK;
>         return 0;
>  }
>
> --
> 1.7.10.280.gaa39
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
With warm regards,
Sachin
