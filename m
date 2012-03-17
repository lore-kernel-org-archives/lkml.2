Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2CQQUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 12:20:13 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:44621 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2CQQUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 12:20:10 -0400
From: Oliver Neukum <oliver@neukum.org>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Subject: Re: [PATCH] [media] staging: Return -EINTR in s2250_probe() if fails to get lock.
Date: Sat, 17 Mar 2012 17:20:16 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org, khoroshilov@ispras.ru,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1331915038-11231-1-git-send-email-santoshprasadnayak@gmail.com> <201203161859.35104.oliver@neukum.org> <CAOD=uF6wD1sx2=Rk3ZaxtykBR32_GMsHmiuXuAQP2U_=c-Ytbw@mail.gmail.com>
In-Reply-To: <CAOD=uF6wD1sx2=Rk3ZaxtykBR32_GMsHmiuXuAQP2U_=c-Ytbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203171720.16945.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 17. März 2012, 17:00:36 schrieb santosh prasad nayak:
> Oliver,
> 
> The following changes are for review only  not a formal patch.
> 
> -------------------------------------------------------------------------------------------------------------
> -       if (mutex_lock_interruptible(&usb->i2c_lock) == 0) {
> +       mutex_lock(&usb->i2c_lock);
>                 data = kzalloc(16, GFP_KERNEL);
> -               if (data != NULL) {
> +               if(data == NULL) {
> +                       i2c_unregister_device(audio);
> +                       kfree(state);
> +                       return -ENOMEM;
> +               } else {
>                         int rc;
>                         rc = go7007_usb_vendor_request(go, 0x41, 0, 0,
>                                                        data, 16, 1);
> @@ -657,7 +661,7 @@ static int s2250_probe(struct i2c_client *client,
>                         kfree(data);
>                 }
>                 mutex_unlock(&usb->i2c_lock);
> -       }
> +
> 
> ----------------------------------------------------------------------
> 
> 
> Is it ok ?

Hi,

well done. That's correct.

	Regards
		Oliver
