Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2AWLp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 06:45:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2AWLp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 06:45:26 -0500
Message-ID: <4F1D4852.9070002@redhat.com>
Date: Mon, 23 Jan 2012 09:45:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
CC: linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [v3.3-rc1] media:dvb-t regression bisected
References: <CADDKRnDHvptV_gODG8XgqEkWGW0AyDfJJkP1dU2uBL6rs5yzDA@mail.gmail.com>
In-Reply-To: <CADDKRnDHvptV_gODG8XgqEkWGW0AyDfJJkP1dU2uBL6rs5yzDA@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-01-2012 13:29, Jörg Otte escreveu:
> with v3.3-rc1 I can not watch dvb-t. I get the following
> errors from the media player (Kaffeine,vlc):
> 
> kaffeine(1801): DvbDevice::frontendEvent: tuning failed
> vlc: [0xa278d78] main stream error: cannot pre fill buffer
> 
> I have a CinergyT2 usb-stick.
> 
> I was able to bisect the problem to:
> commit 7830bbaff9f5f9cefcdc9acfb1783b230cc69fac
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Mon Dec 26 15:41:01 2011 -0300
> 
> [media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters

Could you please try this patch?

[PATCH] cinergyT2-fe: Fix bandwdith settings

Changeset 7830bbaff9f mangled the bandwidth field for CinergyT2.
Properly fill it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
index 8a57ed8..1efc028 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
@@ -276,14 +276,15 @@ static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe)
 	param.flags = 0;
 
 	switch (fep->bandwidth_hz) {
+	default:
 	case 8000000:
-		param.bandwidth = 0;
+		param.bandwidth = 8;
 		break;
 	case 7000000:
-		param.bandwidth = 1;
+		param.bandwidth = 7;
 		break;
 	case 6000000:
-		param.bandwidth = 2;
+		param.bandwidth = 6;
 		break;
 	}
 
