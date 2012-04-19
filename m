Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2DSTs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:48:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab2DSTs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:48:56 -0400
Message-ID: <4F906C22.6090101@redhat.com>
Date: Thu, 19 Apr 2012 16:48:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 07/12] drivers: media: video: tm6000: tm6000.h: Include
 version.h header
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com> <1334723412-5034-8-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1334723412-5034-8-git-send-email-marcos.souza.org@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-04-2012 01:30, Marcos Paulo de Souza escreveu:
> The output of "make versioncheck" told us that:
> 
> drivers/media/video/tm6000/tm6000.h: 401: need linux/version.h
> 
> If we take a look at the code, we can see the use of the macro
> KERNEL_VERSION. So, we need this include.
> 
> In this patch too, the headers of the file were reordered in alphabetic
> order. No functional changes here.
> 
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: <linux-media@vger.kernel.org >
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Nack. See enclosed.

commit d8a9c01484b258573587a52c3226bbdf6d11cda6
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Thu Apr 19 16:35:27 2012 -0300

    [media] tlg2300: Remove usage of KERNEL_VERSION()
    
    As reported by Marcos:
    
    On 04-18-2012 01:30, Marcos Paulo de Souza wrote:
    > The output of "make versioncheck" told us that:
    >
    > drivers/media/video/tlg2300/pd-video.c: 1669: need linux/version.h
    >
    > If we take a look at the code, we can see that this file uses the macro
    > KERNEL_VERSION.
    
    The V4L2 core now fills it automatically, so drivers shouldn't touch on
    cap->version anymore.
    
    Reported by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index a794ae6..bfbf9e5 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -150,7 +150,6 @@ static int vidioc_querycap(struct file *file, void *fh,
 	strcpy(cap->driver, "tele-video");
 	strcpy(cap->card, "Telegent Poseidon");
 	usb_make_path(p->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->version = KERNEL_VERSION(0, 0, 1);
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
 				V4L2_CAP_AUDIO | V4L2_CAP_STREAMING |
 				V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
