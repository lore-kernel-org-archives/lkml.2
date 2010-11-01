Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab0KANV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:21:56 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3905 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab0KANVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:21:55 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 09:21:54 EDT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] V4L/DVB: tea6415c: return -EIO if i2c_check_functionality fails
Date: Mon, 1 Nov 2010 14:13:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-tschai; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
References: <1288603539.3831.2.camel@mola>
In-Reply-To: <1288603539.3831.2.camel@mola>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011011413.37411.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 01, 2010 10:25:39 Axel Lin wrote:
> If the adapter does not support I2C_FUNC_SMBUS_WRITE_BYTE,
> return -EIO instead of 0.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

> ---
>  drivers/media/video/tea6415c.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
> index 3e99cea..19621ed 100644
> --- a/drivers/media/video/tea6415c.c
> +++ b/drivers/media/video/tea6415c.c
> @@ -148,7 +148,7 @@ static int tea6415c_probe(struct i2c_client *client,
>  
>  	/* let's see whether this adapter can support what we need */
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_WRITE_BYTE))
> -		return 0;
> +		return -EIO;
>  
>  	v4l_info(client, "chip found @ 0x%x (%s)\n",
>  			client->addr << 1, client->adapter->name);
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
