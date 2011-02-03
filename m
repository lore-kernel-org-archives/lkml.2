Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1BCGFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 01:05:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43662 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1BCGFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 01:05:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dTIp09dJoAeUjcFYRAgFz8g0Tfb3vSuJPw+tvJp4OzHzKAHvRe9PNXV9hPDxKXYYr+
         h6KVic7UjdKhVttj64Cq5tAjVbg1iUvWUj9uFa1mvPL41R/hvkI4JEiIXVAUo74BgN7P
         +9GNF3M1p11vc27Iq60gYASMTFiLtxGSanDGI=
Date: Wed, 2 Feb 2011 22:05:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        linux-input@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 12/19] twl4030: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110203060521.GA25739@core.coreip.homeip.net>
References: <20110202195417.228e2656@queued.net>
 <20110202201522.72d37f1e@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202201522.72d37f1e@queued.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 08:15:22PM -0800, Andres Salomon wrote:
>  static int __devinit twl4030_vibra_probe(struct platform_device *pdev)
>  {
> -	struct twl4030_codec_vibra_data *pdata = pdev->dev.platform_data;
> +	struct twl4030_codec_vibra_data *pdata = platform_get_drvdata(pdev);

No, device's drvdata belongs to _this_ driver, and it is supposed to
manage it and use as it sees fit.

Note platform_set_drvdata(pdev, info) later in this function along with
platform_set_drvdata(pdev, NULL) in twl4030_vibra_remove(), which means
that with your change you will be able to bind the device only once.

-- 
Dmitry
