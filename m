Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0G1U7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:59:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56171 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0G1U7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Z5XW3/AEQ6mbo9CTT20ssTDp5ODw6IXHr9dLBmVrFrIfzwz+LCJyYZ+DWWOnIpu53i
         PcSdp0CC8J9T3umsNi4iLCfSBDXmKIC3NyVf+2vvIw6DRT0WzgXcqQKuduotcnnlalh0
         5mBco3I04SLYeoreBzSLaZxrvGmpakJJLxN60=
Message-ID: <4C509A18.3090607@gmail.com>
Date: Wed, 28 Jul 2010 22:59:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        ss@aao.gov.au, gregkh@suse.de
Subject: Re: [PATCH] Staging: dt3155: properly export the module parameter
References: <201007280948.33247.hartleys@visionengravers.com>
In-Reply-To: <201007280948.33247.hartleys@visionengravers.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 06:48 PM, H Hartley Sweeten wrote:
> Make the module parameter dt3155_major static and add the proper
> wrappers to export it.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Scott Smedley <ss@aao.gov.au>
> ---
> 
> diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
> index 7316996..220eaf9 100644
> --- a/drivers/staging/dt3155/dt3155_drv.c
> +++ b/drivers/staging/dt3155/dt3155_drv.c
> @@ -99,7 +99,9 @@ wait_queue_head_t dt3155_read_wait_queue[MAXBOARDS];
>  
>  /* set to dynamicaly allocate, but it is tunable: */
>  /* insmod DT_3155 dt3155 dt3155_major=XX */
> -int dt3155_major = 0;
> +static int dt3155_major;
> +module_param(dt3155_major, int, 0);
> +MODULE_PARM_DESC(dt3155_major, "Major device number");

Is it necessary in the age of udev?

I would personally get rid of that completely...

regards,
-- 
js
