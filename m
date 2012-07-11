Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2GKJCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:02:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36601 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab2GKJCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:02:02 -0400
Message-ID: <4FFD4105.4050504@arm.com>
Date: Wed, 11 Jul 2012 10:01:57 +0100
From: viresh kumar <viresh.kumar2@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>, Shiraz Hashim <shiraz.hashim@st.com>
CC: David Woodhouse <dwmw2@infradead.org>, Stefan Roese <sr@denx.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] drivers/mtd/devices/spear_smi.c: failure test for null
 rather than negative integer
References: <1341997118-25042-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1341997118-25042-1-git-send-email-Julia.Lawall@lip6.fr>
X-MC-Unique: 112071110015900201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding spear-devel mailing list in cc.

@Shiraz: Can you update ST's mailing list address in entire MAINTAINERS file, so
that people can include ST's list easily?

On 11/07/12 09:58, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> dev_get_platdata returns a pointer, so the failure value would be NULL
> rather than a negative integer.
>
> The semantic match that finds this problem is: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression x,e;
> statement S1,S2;
> @@
>
> *x = dev_get_platdata(...)
> ... when != x = e
> *if (x < 0) S1 else S2
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/mtd/devices/spear_smi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
> index b85f183..7c10466 100644
> --- a/drivers/mtd/devices/spear_smi.c
> +++ b/drivers/mtd/devices/spear_smi.c
> @@ -935,7 +935,7 @@ static int __devinit spear_smi_probe(struct platform_device *pdev)
>               }
>       } else {
>               pdata = dev_get_platdata(&pdev->dev);
> -             if (pdata < 0) {
> +             if (!pdata) {
>                       ret = -ENODEV;
>                       dev_err(&pdev->dev, "no platform data\n");
>                       goto err;

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

--
Viresh

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

