Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab1JEJdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:33:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27675 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583Ab1JEJdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:33:04 -0400
Date: Wed, 5 Oct 2011 12:32:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ospite@studenti.unina.it
Cc: Richard Purdie <rpurdie@rpsys.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: [sparse stuff] bug in lp3944_led_set_brightness()
Message-ID: <20111005093248.GA6792@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E8C2445.0076:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonio,

I was going through some Sparse warnings and this one seems pretty
valid.

drivers/leds/leds-lp3944.c +292 23:
	warning: mixing different enum types

   284  static void lp3944_led_set_brightness(struct led_classdev *led_cdev,
   285                                        enum led_brightness brightness)
   286  {
   287          struct lp3944_led_data *led = ldev_to_led(led_cdev);
   288  
   289          dev_dbg(&led->client->dev, "%s: %s, %d\n",
   290                  __func__, led_cdev->name, brightness);
   291  
   292          led->status = brightness;
                ^^^^^^^^^^^^^^^^^^^^^^^^
   293          schedule_work(&led->work);
   294  }

led->status should be values between 0-3.  brightness is 0, 127 and
255.

regards,
dan carpenter
