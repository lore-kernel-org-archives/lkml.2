Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0ITT2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:28:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51566 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab0ITT2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:28:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH] PM: Fix signed/unsigned warning
Date: Mon, 20 Sep 2010 21:27:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
References: <8136c24e8aaf577b86dfdfc40b0d01e6@localhost>
In-Reply-To: <8136c24e8aaf577b86dfdfc40b0d01e6@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009202127.24691.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 20, 2010, Kevin Cernekee wrote:
> Seen on MIPS32, gcc 4.4.3, 2.6.36-rc4:
> 
> drivers/base/power/main.c: In function 'dpm_show_time':
> drivers/base/power/main.c:415: warning: comparison of distinct pointer types lacks a cast
> 
> do_div() takes unsigned parameters:
> 
> uint32_t do_div(uint64_t *n, uint32_t base);
> 
> Using an unsigned variable for usecs64 should not cause any problems,
> because calltime >= starttime .
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

OK, I'm going to apply it.

Thanks,
Rafael


> ---
>  drivers/base/power/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 276d5a7..db67719 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -407,7 +407,7 @@ static void pm_dev_err(struct device *dev, pm_message_t state, char *info,
>  static void dpm_show_time(ktime_t starttime, pm_message_t state, char *info)
>  {
>  	ktime_t calltime;
> -	s64 usecs64;
> +	u64 usecs64;
>  	int usecs;
>  
>  	calltime = ktime_get();
> 

