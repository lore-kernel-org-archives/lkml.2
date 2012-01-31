Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2AaWTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:19:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2AaWTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:19:10 -0500
Date: Tue, 31 Jan 2012 14:19:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philip Prindeville <philipp@redfish-solutions.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] net5501: platform driver for Soekris Engineering
 net5501 single-board computer
Message-Id: <20120131141908.2c4c8b13.akpm@linux-foundation.org>
In-Reply-To: <1327726939-20845-1-git-send-email-philipp@redfish-solutions.com>
References: <1325323722-25930-1-git-send-email-philipp@redfish-solutions.com>
	<1327726939-20845-1-git-send-email-philipp@redfish-solutions.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 22:02:19 -0700
Philip Prindeville <philipp@redfish-solutions.com> wrote:

> ---
> Trivial platform driver for Soekris Engineering net5501 single-board
> computer. Probes well-known locations in ROM for BIOS signature to
> confirm correct platform. Registers 1 LED and 1 GPIO-based button
> (typically used for soft reset).
> 
> ...
>
>  arch/x86/Kconfig                  |    6 ++
>  arch/x86/platform/geode/Makefile  |    1 +
>  arch/x86/platform/geode/net5501.c |  154 +++++++++++++++++++++++++++++++++++++
>  drivers/leds/leds-net5501.c       |   97 -----------------------

Forgot to clean up the leftovers:

make[2]: *** No rule to make target `drivers/leds/leds-net5501.c', needed by `drivers/leds/leds-net5501.o'.  Stop.

Also, are you sure that the new Kconfig entry is sufficient?  The old
driver had more dependencies (GPIO_CS5535 and LEDS_TRIGGERS) and
selects LEDS_TRIGGER_DEFAULT_ON.  Should the new driver be doing such
things?


--- a/drivers/leds/Kconfig~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix
+++ a/drivers/leds/Kconfig
@@ -89,16 +89,6 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
-config LEDS_NET5501
-	tristate "LED Support for Soekris net5501 series Error LED"
-	depends on LEDS_TRIGGERS
-	depends on X86 && GPIO_CS5535
-	select LEDS_TRIGGER_DEFAULT_ON
-	default n
-	help
-	  Add support for the Soekris net5501 board (detection, error led
-	  and GPIO).
-
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
 	depends on LEDS_CLASS
--- a/drivers/leds/Makefile~net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer-fix
+++ a/drivers/leds/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= led
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
-obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
_



