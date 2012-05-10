Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480Ab2EJATp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:19:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42155 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761450Ab2EJATm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:19:42 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+ql/BS4D+qx99208nbTUlGL2LNPeyPdZB4b9xT/j
	1vVMYBzL7W9bCN
Message-ID: <4FAB0996.5000405@gmx.de>
Date: Thu, 10 May 2012 00:19:34 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] video/via: Convert to kstrtou8_from_user
References: <CACVxJT96rXRqMoeabdDyNEjXCubuAnQ_fonisbopQvYL=Qhp2w@mail.gmail.com> <1336090997-23727-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1336090997-23727-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 12:23 AM, Peter Huewe wrote:
> This patch replaces the code for getting an number from a
> userspace buffer by a simple call to kstrou8_from_user.
> This makes it easier to read and less error prone.
> 
> v2:
> removed initialization of reg_val and dropped check if count < 1
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
> @Alexey: Thanks for the review/feedback!
>  drivers/video/via/viafbdev.c |   34 ++++++++++++----------------------
>  1 files changed, 12 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index a13c258..88bf5ba 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c
> @@ -1279,17 +1279,12 @@ static int viafb_dfph_proc_open(struct inode *inode, struct file *file)
>  static ssize_t viafb_dfph_proc_write(struct file *file,
>  	const char __user *buffer, size_t count, loff_t *pos)
>  {
> -	char buf[20];
> -	u8 reg_val = 0;
> -	unsigned long length;
> -	if (count < 1)
> -		return -EINVAL;
> -	length = count > 20 ? 20 : count;
> -	if (copy_from_user(&buf[0], buffer, length))
> -		return -EFAULT;
> -	buf[length - 1] = '\0';	/*Ensure end string */
> -	if (kstrtou8(buf, 0, &reg_val) < 0)
> -		return -EINVAL;
> +	int err;
> +	u8 reg_val;
> +	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
> +	if (err)
> +		return err;
> +
>  	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
>  	return count;
>  }
> @@ -1319,17 +1314,12 @@ static int viafb_dfpl_proc_open(struct inode *inode, struct file *file)
>  static ssize_t viafb_dfpl_proc_write(struct file *file,
>  	const char __user *buffer, size_t count, loff_t *pos)
>  {
> -	char buf[20];
> -	u8 reg_val = 0;
> -	unsigned long length;
> -	if (count < 1)
> -		return -EINVAL;
> -	length = count > 20 ? 20 : count;
> -	if (copy_from_user(&buf[0], buffer, length))
> -		return -EFAULT;
> -	buf[length - 1] = '\0';	/*Ensure end string */
> -	if (kstrtou8(buf, 0, &reg_val) < 0)
> -		return -EINVAL;
> +	int err;
> +	u8 reg_val;
> +	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
> +	if (err)
> +		return err;
> +
>  	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
>  	return count;
>  }

