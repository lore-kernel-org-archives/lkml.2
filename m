Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2FTALa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 20:11:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2FTAL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 20:11:29 -0400
Date: Tue, 19 Jun 2012 17:11:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Len Brown <len.brown@intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: Constify 'type' argument for the registration
 routine
Message-Id: <20120619171128.377fc971.akpm@linux-foundation.org>
In-Reply-To: <1339995037-19561-1-git-send-email-cbouatmailru@gmail.com>
References: <1339995037-19561-1-git-send-email-cbouatmailru@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012 21:50:37 -0700
Anton Vorontsov <anton.vorontsov@linaro.org> wrote:

> thermal_zone_device_register() does not modify 'type' argument, so
> it is safe to declare it as const. Otherwise, if we pass a const
> string, we are getting the ugly warning:
> 
> ...
>

For some reason I can't apply this.  I typed it in again and it seems
to work OK.  I'll assume that someone else will merge it into
whatever-tree-broke.

> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -137,7 +137,8 @@ enum {
>  };
>  #define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
>  
> -struct thermal_zone_device *thermal_zone_device_register(char *, int, void *,
> +struct thermal_zone_device *
> +thermal_zone_device_register(const char *, int, void *,
>  		const struct thermal_zone_device_ops *, int tc1, int tc2,
>  		int passive_freq, int polling_freq);
>  void thermal_zone_device_unregister(struct thermal_zone_device *);

Personally, I prefer it when the arguments are named in the declaration
- if you ever have reason to *read* the thing, the lack of names is
quite maddening.  Particularly when the function has 72 arguments.

But naming some of them and not others is just daft.
