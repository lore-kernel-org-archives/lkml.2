Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab2HILiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757847Ab2HILiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:38:09 -0400
Message-ID: <5023A11C.50502@redhat.com>
Date: Thu, 09 Aug 2012 08:38:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL for 3.6-rc1] media updates part 2
References: <5017F674.80404@redhat.com> <alpine.DEB.2.00.1208081526320.11542@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1208081526320.11542@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-08-2012 19:28, David Rientjes escreveu:
> On Tue, 31 Jul 2012, Mauro Carvalho Chehab wrote:
> 
>>        [media] radio-shark: New driver for the Griffin radioSHARK USB radio receiver
> 
> This one gives me a build warning if CONFIG_LEDS_CLASS is disabled:
> 
> ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
> ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!
> 

Could you please test the enclosed patch?

Thanks!
Mauro

-

[media] radio-shark: make sure LEDS_CLASS is selected

As reported by David:
	> ERROR: "led_classdev_register" [drivers/media/radio/shark2.ko] undefined!
	> ERROR: "led_classdev_unregister" [drivers/media/radio/shark2.ko] undefined!

Reported-by: Dadiv Rientjes <rientjes@google.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 8090b87..be68ec2 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -60,6 +60,7 @@ config RADIO_MAXIRADIO
 config RADIO_SHARK
 	tristate "Griffin radioSHARK USB radio receiver"
 	depends on USB && SND
+	select LEDS_CLASS
 	---help---
 	  Choose Y here if you have this radio receiver.
 
@@ -77,6 +78,7 @@ config RADIO_SHARK
 config RADIO_SHARK2
 	tristate "Griffin radioSHARK2 USB radio receiver"
 	depends on USB
+	select LEDS_CLASS
 	---help---
 	  Choose Y here if you have this radio receiver.
 

