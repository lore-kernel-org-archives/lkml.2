Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453Ab2CTWCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:02:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab2CTWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:02:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bernhard Walle <walle@corscience.de>
Subject: Re: [PATCH] mfd: Add TWL4030 PWM driver
Date: Tue, 20 Mar 2012 22:02:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <1332262083-9375-1-git-send-email-walle@corscience.de>
In-Reply-To: <1332262083-9375-1-git-send-email-walle@corscience.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203202202.12060.arnd@arndb.de>
X-Provags-ID: V02:K0:ODCAL7OO5am8wVBEI52hDUrj0MnplABgej2KkaPOyaT
 dxhtlSg8q2Z+vUUXU2Hzn31JTB//sY+N72z49/+twMW84A5Pdq
 8hmG+pbLa0mDlzAMsyvVMoUrehauJI8PVzXbsHvHbiBdiDSSys
 4GI7M8AVgWeUy0puv+vay9U8PqUTPaZD9wdrCTMTyAtw6Q/aic
 H48kiQ1EL+5vj1dSuWMgbzwz6f1Xgf0vEu8HBaaqC2qMN6nTtw
 ZlM1l/0Q1ocD6JTIeE0NYpsI81O9Pkq32J1iIqqUmeE1AzX9zL
 Us3zCsTmjXdXTr088Dh35TewQsEH/REusmRuW2QAvdNzP8eQGD
 W9DQbFPMN5N5QumdpDW4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 March 2012, Bernhard Walle wrote:
> 
> This PWM driver uses the PWM of the TWL4030. The driver for the TWL6030
> PWM has been used as mode, but the PWM registers are different.
> 
> The driver can be used and has been tested in conjunction with
> pwm-backlight to control a backlight LED of a LCD touch screen.
> 
> Signed-off-by: Bernhard Walle <walle@corscience.de>

Since it's too late for v3.4 now and we will get a new pwm
subsystem in v3.5, I suggest you change the driver to work
register with that subsystem instead of just using the old
header file. Note that drivers/mfd is not really the right
place anyway, because this is not a multifunction driver but
just one device driver that happens to be a slave of an mfd.

	Arnd
