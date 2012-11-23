Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab2KWDRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 22:17:18 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:32771 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928Ab2KWDRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 22:17:17 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 22:17:17 EST
Date: Fri, 23 Nov 2012 05:07:29 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Barry Song <Barry.Song@csr.com>
Cc: gregkh@linuxfoundation.org, workgroup.linux@csr.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH] printk: add boot_quiet param to support deferred
 printk while booting
Message-ID: <20121123030729.GB4030@tarshish>
References: <1353639022-13273-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353639022-13273-1-git-send-email-Barry.Song@csr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Barry,

On Fri, Nov 23, 2012 at 10:50:22AM +0800, Barry Song wrote:

[...]

> diff --git a/kernel/printk.c b/kernel/printk.c
> index 2d607f4..0b88d6bf 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -250,6 +250,9 @@ static u32 clear_idx;
>  #define LOG_ALIGN __alignof__(struct log)
>  #endif
>  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> +static char __boot_log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);

Since we do not use this buffer when the system is running, is there a way to 
release it once its content has been written to console?

baruch

> +static int boot_log_len;
> +
>  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
> @@ -1247,6 +1250,16 @@ module_param(ignore_loglevel, bool, S_IRUGO | S_IWUSR);

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
