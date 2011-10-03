Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1JCXaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:30:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45752 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1JCXaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:30:12 -0400
Message-ID: <4E8A457F.5050106@gmail.com>
Date: Tue, 04 Oct 2011 10:30:07 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] Staging: comedi: fix printk issue in cb_pcidas.c
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in> <1317388707-1980-3-git-send-email-ravishankar.km@greenturtles.in>
In-Reply-To: <1317388707-1980-3-git-send-email-ravishankar.km@greenturtles.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/11 23:18, Ravishankar Karkala Mallikarjunayya wrote:

> This is a patch to the cb_pcidas.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/cb_pcidas.c |   21 +++++++++++++--------
>  1 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
> index 9dec153..9d16c6c 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidas.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidas.c
> @@ -565,7 +565,8 @@ static int cb_pcidas_attach(struct comedi_device *dev,
>  	int index;
>  	int i;
>  
> -	pr_info("comedi%d: cb_pcidas: ", dev->minor);
> +	dev_info(&pcidev->dev, "comedi%d: cb_pcidas:\n",
> +		dev->minor);

This printk can probably be removed now. It's just noise. Similar in
other places too.

~Ryan
