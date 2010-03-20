Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0CTHmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 03:42:04 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:59011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab0CTHmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 03:42:01 -0400
Subject: Re: [PATCH] Wireless: Make cfg80211_dev_rename() check sscanf
 return value in net/wireless/core.c
From: Johannes Berg <johannes@sipsolutions.net>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       flamingice@sourmilk.net
In-Reply-To: <20100320045352.GA2949@localhost.localdomain>
References: <20100320045352.GA2949@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 00:39:04 -0700
Message-ID: <1269070744.5740.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 12:53 +0800, wzt.wzt@gmail.com wrote:
> Make cfg80211_dev_rename() check sscanf return value.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
> 
> ---
>  net/wireless/core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 80afacd..8e815b4 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -146,7 +146,9 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
>  	int idx, taken = -1, result, digits;
>  
>  	/* prohibit calling the thing phy%d when %d is not its number */
> -	sscanf(newname, PHY_NAME "%d%n", &idx, &taken);
> +	if (sscanf(newname, PHY_NAME "%d%n", &idx, &taken) != 2)
> +		return -EINVAL;
> +

Umm, no, your patch breaks it completely. Look at the logic again.

johannes

