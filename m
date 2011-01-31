Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1AaKMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:12:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51432 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1AaKMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:12:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 3/6] PM: use appropriate printk priority level
Date: Mon, 31 Jan 2011 11:12:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: gregkh@suse.de, mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20110125235700.GR8008@google.com> <1296084570-31453-4-git-send-email-msb@chromium.org>
In-Reply-To: <1296084570-31453-4-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311112.29528.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 27, 2011, Mandeep Singh Baines wrote:
> printk()s without a priority level default to KERN_WARNING. To reduce
> noise at KERN_WARNING, this patch set the priority level appriopriately
> for unleveled printks()s. This should be useful to folks that look at
> dmesg warnings closely.
> 
> Changed these messages to pr_info. But might be more appropriate as
> pr_debug.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
>  drivers/base/power/trace.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
> index 9f4258d..c80e138 100644
> --- a/drivers/base/power/trace.c
> +++ b/drivers/base/power/trace.c
> @@ -112,7 +112,7 @@ static unsigned int read_magic_time(void)
>  	unsigned int val;
>  
>  	get_rtc_time(&time);
> -	printk("Time: %2d:%02d:%02d  Date: %02d/%02d/%02d\n",
> +	pr_info("Time: %2d:%02d:%02d  Date: %02d/%02d/%02d\n",
>  		time.tm_hour, time.tm_min, time.tm_sec,
>  		time.tm_mon + 1, time.tm_mday, time.tm_year % 100);
>  	val = time.tm_year;				/* 100 years */
> @@ -179,7 +179,7 @@ static int show_file_hash(unsigned int value)
>  		unsigned int hash = hash_string(lineno, file, FILEHASH);
>  		if (hash != value)
>  			continue;
> -		printk("  hash matches %s:%u\n", file, lineno);
> +		pr_info("  hash matches %s:%u\n", file, lineno);
>  		match++;
>  	}
>  	return match;
> @@ -255,7 +255,7 @@ static int late_resume_init(void)
>  	val = val / FILEHASH;
>  	dev = val /* % DEVHASH */;
>  
> -	printk("  Magic number: %d:%d:%d\n", user, file, dev);
> +	pr_info("  Magic number: %d:%d:%d\n", user, file, dev);
>  	show_file_hash(file);
>  	show_dev_hash(dev);
>  	return 0;
> 

