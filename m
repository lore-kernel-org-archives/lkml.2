Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab2FIMlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 08:41:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33470 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752491Ab2FIMlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 08:41:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+Y0YolJrKYNWl6OjAqkKI3GeXL+kk9t1AC4hso1N
	sCQcppQe7WBSLJ
Message-ID: <4FD3448B.2050806@gmx.de>
Date: Sat, 09 Jun 2012 12:41:47 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] video: bfin_adv7393fb: Convert to kstrtouint_from_user
References: <1338310620-6886-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1338310620-6886-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 04:57 PM, Emil Goode wrote:
> This patch removes a call to the deprecated simple_strtoul function
> and simplifies the code by replacing two function calls with one
> call to kstrtouint_from_user.
> 
> -Simplify the adv7393_write_proc function by replacing the
>  simple_strtoul and copy_from_user calls with one call
>  to kstrtouint_from_user.
> 
> -Change the count parameter from unsigned long to size_t as
>  this is the type that the kstrtouint_from_user function expects.
>  (size_t is what will be passed to the adv7393_write_proc function
>  by the proc write handler function proc_file_write anyway)
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/bfin_adv7393fb.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/video/bfin_adv7393fb.c b/drivers/video/bfin_adv7393fb.c
> index 1a268a2..8c6edfd 100644
> --- a/drivers/video/bfin_adv7393fb.c
> +++ b/drivers/video/bfin_adv7393fb.c
> @@ -353,18 +353,16 @@ adv7393_read_proc(char *page, char **start, off_t off,
>  
>  static int
>  adv7393_write_proc(struct file *file, const char __user * buffer,
> -		   unsigned long count, void *data)
> +		   size_t count, void *data)
>  {
>  	struct adv7393fb_device *fbdev = data;
> -	char line[8];
>  	unsigned int val;
>  	int ret;
>  
> -	ret = copy_from_user(line, buffer, count);
> +	ret = kstrtouint_from_user(buffer, count, 0, &val);
>  	if (ret)
>  		return -EFAULT;
>  
> -	val = simple_strtoul(line, NULL, 0);
>  	adv7393_write(fbdev->client, val >> 8, val & 0xff);
>  
>  	return count;

