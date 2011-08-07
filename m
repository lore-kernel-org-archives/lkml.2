Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1HGRg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:36:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50985 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754031Ab1HGRgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:36:54 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+B3rdXo22BSpaJ2AM+pxYjOMrwoSJdT/gqlSK5BQ
	sBhXf86mgX7Ry2
Message-ID: <4E3ECD32.1050802@gmx.de>
Date: Sun, 07 Aug 2011 17:36:50 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: stufever@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: Re: [PATCH V2] replace strict_strtoul to kstrto[*] and check return
 value
References: <1312730922-1211-1-git-send-email-wangshaoyan.pt@taobao.com>
In-Reply-To: <1312730922-1211-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On 08/07/2011 03:28 PM, stufever@gmail.com wrote:
> From: Wang Shaoyan<wangshaoyan.pt@taobao.com>
>
> Change since V1:
>    1.use kstrto*, not kstrtoul
>    2.replace&buf[0] to buf

it is good that you wrote what you changed. But it would be better if you write 
it below the commit message like this

<commit message>

Signed-off-by:
---
    drivers/video/via/viafbdev.c |  126 ++++++++++++++++++++++-------------------
    1 files changed, 68 insertions(+), 58 deletions(-)

Change since V1:

as nobody really cares what changed in different patch versions once the final 
version is applied in git. And if you do it this way I could just do "git am -s 
<patch>" and would get the commit message without the history.

> This commit replace the function strict_strtoul(becasue commit 33ee3b2e), and check the return value to avoid such warning:
>
>    drivers/video/via/viafbdev.c:1992: warning: ignoring return value of 'kstrtoul', declared with attribute warn_unused_result

Thanks this looks much saner. Just 2 little issues before it is good enough, I 
think.

./scripts/checkpatch.pl ./\[PATCH\ V2\]\ replace\ strict_strtoul\ to\ 
kstrto\[\*\]\ and\ check\ return\ value.eml
ERROR: trailing whitespace
#173: FILE: drivers/video/via/viafbdev.c:1974:
+^I^I^Iif (kstrtoint(this_opt + 21, 0, $

ERROR: trailing whitespace
#177: FILE: drivers/video/via/viafbdev.c:1978:
+^I^I^Iif (kstrtoint(this_opt + 19, 0, $

ERROR: trailing whitespace
#212: FILE: drivers/video/via/viafbdev.c:1991:
+^I^I^Iif (kstrtoint(this_opt + 30, 0, $

ERROR: trailing whitespace
#220: FILE: drivers/video/via/viafbdev.c:1999:
+^I^I^Iif (kstrtoint(this_opt + 24, 0, $

total: 4 errors, 0 warnings, 173 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
       scripts/cleanfile

./[PATCH V2] replace strict_strtoul to kstrto[*] and check return value.eml has 
style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Can you please fix those?


> Signed-off-by: Wang Shaoyan<wangshaoyan.pt@taobao.com>
> ---
>   drivers/video/via/viafbdev.c |  126 ++++++++++++++++++++++-------------------
>   1 files changed, 68 insertions(+), 58 deletions(-)
>
> diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> index 53aa443..7074fc7 100644
> --- a/drivers/video/via/viafbdev.c
> +++ b/drivers/video/via/viafbdev.c

[snip]

> @@ -1325,7 +1328,8 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
>   	if (copy_from_user(&buf[0], buffer, length))
>   		return -EFAULT;
>   	buf[length - 1] = '\0';	/*Ensure end string */
> -	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	if (kstrtou8(buf, -1,&reg_val)<  0)
> +		return -EINVAL;
>   	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
>   	return count;
>   }

Using -1 instead 0 as base here? Why? What does this cause?
I assume that it should be 0.


Thanks,

Florian Tobias Schandinat
