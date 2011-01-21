Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1AUSFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:05:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64630 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1AUSFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:05:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=drdald6eqTGd/FhFhEY67R10JixL9P8ays66aivT6jDM8ndc1DYC5n8NToxclB0yiY
         oJvwnxI7N5PRIN3RwE91yO62YmriXDkGmNp7R1U4Z37oH4uaW641AUAZ7StLjBkJnV45
         JGVM4dkfI6NiHpuX3MPTQwFs36AihETY8yEaQ=
From: Marek Vasut <marek.vasut@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] video: pxa168fb: remove a redundant pxa168fb_check_var call
Date: Fri, 21 Jan 2011 19:07:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel@lists.infradead.org
References: <1295608686.3976.9.camel@phoenix>
In-Reply-To: <1295608686.3976.9.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101211907.07386.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 January 2011 12:18:06 Axel Lin wrote:
> Current implementation calls pxa168fb_check_var twice in pxa168fb_probe.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/pxa168fb.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
> index cea6403..35f61dd 100644
> --- a/drivers/video/pxa168fb.c
> +++ b/drivers/video/pxa168fb.c
> @@ -701,16 +701,12 @@ static int __devinit pxa168fb_probe(struct
> platform_device *pdev) */
>  	pxa168fb_init_mode(info, mi);
> 
> -	ret = pxa168fb_check_var(&info->var, info);
> -	if (ret)
> -		goto failed_free_fbmem;
> -
>  	/*
>  	 * Fill in sane defaults.
>  	 */
>  	ret = pxa168fb_check_var(&info->var, info);
>  	if (ret)
> -		goto failed;
> +		goto failed_free_fbmem;
> 
>  	/*
>  	 * enable controller clock

Please, don't use the get_maintainers script. This CCs too many people, really. 
As for pxa168, only CC linux-arm-kernel, Eric, Haojian and that's about it 
(fixed). Thanks

I can't comment on the code, though Haojian, is there any particular reason why 
the call's twice in there? Maybe some HW quirk or something?

Cheers
