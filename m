Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2BEPMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 10:12:25 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:40955
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab2BEPMX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 10:12:23 -0500
X-SpamScore: -5
X-BigFish: VS-5(zz1432N98dKzz1202hzz8275eha1495iz2dh2a8h668h839h8e2h8e3hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikey@neuling.org" <mikey@neuling.org>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: fsl-diu: enable_lcdc() takes a pointer, not struct...
Thread-Topic: fsl-diu: enable_lcdc() takes a pointer, not struct...
Thread-Index: AQHM489mVjZ35F6q7kuJe2WH8f4CK5Yuzg0A
Date: Sun, 5 Feb 2012 15:12:18 +0000
Message-ID: <4F2E9C50.3050500@freescale.com>
References: <20120205062835.GA23916@ZenIV.linux.org.uk>
In-Reply-To: <20120205062835.GA23916@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0)
 Gecko/20120129 Firefox/10.0 SeaMonkey/2.7
x-originating-ip: [68.203.23.46]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <586E73C9EF3180409C26ED20A1CF184B@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> A couple of places missed in commit ddd3d905436b572ebadc09dcf2d12ca5b37020a0...
>
> Signed-off-by: Al Viro<viro@zeniv.linux.org.uk>

This is already fixed in fbdev, although I can't find the patch in the 
archives (http://marc.info/?l=linux-fbdev&r=3&b=201201&w=2).

>
> diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
> index acf292b..629ae00 100644
> --- a/drivers/video/fsl-diu-fb.c
> +++ b/drivers/video/fsl-diu-fb.c
> @@ -1432,7 +1432,7 @@ static int fsl_diu_suspend(struct platform_device *ofdev, pm_message_t state)
>   	struct fsl_diu_data *data;
>
>   	data = dev_get_drvdata(&ofdev->dev);
> -	disable_lcdc(data->fsl_diu_info[0]);
> +	disable_lcdc(&data->fsl_diu_info[0]);
>
>   	return 0;
>   }
> @@ -1442,7 +1442,7 @@ static int fsl_diu_resume(struct platform_device *ofdev)
>   	struct fsl_diu_data *data;
>
>   	data = dev_get_drvdata(&ofdev->dev);
> -	enable_lcdc(data->fsl_diu_info[0]);
> +	enable_lcdc(&data->fsl_diu_info[0]);
>
>   	return 0;
>   }
>


-- 
Timur Tabi
Linux kernel developer at Freescale
