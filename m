Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab1ANJHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:07:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab1ANJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SLGk40Nfyccgsxqi9vK2JPheKbCGqfEiCzMD5QAK+xiSBaDU4+0LfPubeNwuMEbgJa
         pD6RXwODpM5Nc8Qokj++x2g0dAWQQuthCPLumsueMbKzJEF8wrZ3PpXJhu7m7UMhYFDn
         wpaXGrdbwoeGXmCrjWjADAWz2VZzvuJBX6b2A=
Message-ID: <4D301239.5030303@gmail.com>
Date: Fri, 14 Jan 2011 10:07:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@suse.de>
Subject: Re: [PATCH] tty/tty_io.c: fix compilation warning
References: <1294989497-2531-1-git-send-email-viresh.kumar@st.com>
In-Reply-To: <1294989497-2531-1-git-send-email-viresh.kumar@st.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 08:18 AM, Viresh Kumar wrote:
> This patch fixes following compilation warning:
> tty/tty_io.c:3309: warning: ignoring return value of 'device_create_file',
> declared with attribute warn_unused_result
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/tty/tty_io.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 464d09d..b558f03 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -3291,6 +3291,8 @@ void console_sysfs_notify(void)
>   */
>  int __init tty_init(void)
>  {
> +	int ret = 0;
> +
>  	cdev_init(&tty_cdev, &tty_fops);
>  	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
>  	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
> @@ -3306,11 +3308,11 @@ int __init tty_init(void)
>  	if (IS_ERR(consdev))
>  		consdev = NULL;
>  	else
> -		device_create_file(consdev, &dev_attr_active);
> +		ret = device_create_file(consdev, &dev_attr_active);
>  
>  #ifdef CONFIG_VT
>  	vty_init(&console_fops);
>  #endif
> -	return 0;
> +	return ret;

NACK

There is no failpath handling. And I think Kay has a patch for that
already where he ignores the retval.

regards,
-- 
js
