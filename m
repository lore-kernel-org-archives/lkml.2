Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab2IMHvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:51:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2IMHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:51:33 -0400
Date: Thu, 13 Sep 2012 00:56:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120913005657.1ae79a95.akpm@linux-foundation.org>
In-Reply-To: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
References: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012 17:44:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

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
> ...
>
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -9,7 +9,7 @@
>   *  it under the terms of the GNU General Public License as published by
>   *  the Free Software Foundation; version 2 of the License.
>   *
> - *  This program is distributed in the hope that it will be useful, but
> + *  This program is distributed in the hope that it will be useful, butX_ID_MASK
>   *  WITHOUT ANY WARRANTY; without even the implied warranty of
>   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>   *  General Public License for more details.
> @@ -86,7 +86,7 @@ again:
>  	else if (unlikely(err))
>  		return err;
>  
> -	*id = *id & MAX_ID_MASK;
> +	*id = *id & MAX_IDR_MASK;
>  	return 0;
>  }

Confused. 
http://ozlabs.org/~akpm/mmotm/broken-out/idr-rename-max_level-to-max_idr_level-fix-3.patch
already does this.  How did that change get into the wrong place?

