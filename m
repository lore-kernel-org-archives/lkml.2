Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030479Ab2CGWFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:05:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60202 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2CGWE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:04:58 -0500
Date: Wed, 7 Mar 2012 14:04:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 01/13] android: lowmemorykiller: Fix warning on 64bit
Message-ID: <20120307220454.GA16555@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
 <1331157503-3413-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1331157503-3413-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:58:11PM -0800, John Stultz wrote:
> Fixes the following warning on 64bit:
> drivers/staging/android/lowmemorykiller.c: In function ‘__check_minfree’:
> drivers/staging/android/lowmemorykiller.c:215: warning: return from incompatible pointer type
> 
> CC: Greg KH <gregkh@linuxfoundation.org>
> CC: Android Kernel Team <kernel-team@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/lowmemorykiller.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> index 052b43e..15a59c1 100644
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -212,7 +212,7 @@ static void __exit lowmem_exit(void)
>  module_param_named(cost, lowmem_shrinker.seeks, int, S_IRUGO | S_IWUSR);
>  module_param_array_named(adj, lowmem_adj, int, &lowmem_adj_size,
>  			 S_IRUGO | S_IWUSR);
> -module_param_array_named(minfree, lowmem_minfree, uint, &lowmem_minfree_size,
> +module_param_array_named(minfree, lowmem_minfree, ulong, &lowmem_minfree_size,
>  			 S_IRUGO | S_IWUSR);

No, the correct fix for this is to make lowmem_minfree an int, not
size_t, right?  I made that fix an hour ago in my tree.

thanks,

greg k-h
