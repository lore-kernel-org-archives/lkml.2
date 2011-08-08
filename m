Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1HHALL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 20:11:11 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49915 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753180Ab1HHALB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:11:01 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX199pLQHGcR9qF2oB/8gcN7dcD3PPXtK5zMBW4qOEi
	o/0QIZBSRZrp5z
Message-ID: <4E3F298F.406@gmx.de>
Date: Mon, 08 Aug 2011 00:10:55 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: stufever@gmail.com
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        lethal@linux-sh.org, Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: Re: [PATCH V2] viafb: replace strict_strtoul to kstrto* and check
 return value
References: <1312760553-2143-1-git-send-email-wangshaoyan.pt@taobao.com>
In-Reply-To: <1312760553-2143-1-git-send-email-wangshaoyan.pt@taobao.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2011 11:42 PM, stufever@gmail.com wrote:
> diff --git drivers/video/via/viafbdev.c drivers/video/via/viafbdev.c

Um, you did something different this time, causing another (not critical) 
checkpatch warning
WARNING: patch prefix 'drivers' exists, appears to be a -p0 patch

> @@ -1325,7 +1328,8 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
>   	if (copy_from_user(&buf[0], buffer, length))
>   		return -EFAULT;
>   	buf[length - 1] = '\0';	/*Ensure end string */
> -	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
> +	if (kstrtou8(buf, -1,&reg_val)<  0)

Did you miss my comment about the -1 above last time? Why it is there?

> +		return -EINVAL;
>   	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
>   	return count;
>   }

Thanks,

Florian Tobias Schandinat
