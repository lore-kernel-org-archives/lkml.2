Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2AWPKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:10:01 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47943 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974Ab2AWPKA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:10:00 -0500
MIME-Version: 1.0
In-Reply-To: <4F1D4852.9070002@redhat.com>
References: <CADDKRnDHvptV_gODG8XgqEkWGW0AyDfJJkP1dU2uBL6rs5yzDA@mail.gmail.com>
	<4F1D4852.9070002@redhat.com>
Date: Mon, 23 Jan 2012 16:09:58 +0100
Message-ID: <CADDKRnAzGH=iF5XycONdXgaNHxHUbZjv_KV7LZ+gBqF1SpYB7A@mail.gmail.com>
Subject: Re: [v3.3-rc1] media:dvb-t regression bisected
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much, the patch works!

Joerg


2012/1/23 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 22-01-2012 13:29, Jörg Otte escreveu:
>> with v3.3-rc1 I can not watch dvb-t. I get the following
>> errors from the media player (Kaffeine,vlc):
>>
>> kaffeine(1801): DvbDevice::frontendEvent: tuning failed
>> vlc: [0xa278d78] main stream error: cannot pre fill buffer
>>
>> I have a CinergyT2 usb-stick.
>>
>> I was able to bisect the problem to:
>> commit 7830bbaff9f5f9cefcdc9acfb1783b230cc69fac
>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date:   Mon Dec 26 15:41:01 2011 -0300
>>
>> [media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters
>
> Could you please try this patch?
>
> [PATCH] cinergyT2-fe: Fix bandwdith settings
>
> Changeset 7830bbaff9f mangled the bandwidth field for CinergyT2.
> Properly fill it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
> index 8a57ed8..1efc028 100644
> --- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
> +++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
> @@ -276,14 +276,15 @@ static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe)
>        param.flags = 0;
>
>        switch (fep->bandwidth_hz) {
> +       default:
>        case 8000000:
> -               param.bandwidth = 0;
> +               param.bandwidth = 8;
>                break;
>        case 7000000:
> -               param.bandwidth = 1;
> +               param.bandwidth = 7;
>                break;
>        case 6000000:
> -               param.bandwidth = 2;
> +               param.bandwidth = 6;
>                break;
>        }
>
