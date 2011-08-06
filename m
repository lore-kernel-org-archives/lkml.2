Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1HFV1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 17:27:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37763 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1HFV1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 17:27:08 -0400
MIME-Version: 1.0
Date: Sat, 6 Aug 2011 23:27:06 +0200
X-Google-Sender-Auth: B9NvmCiW3aia6K-jXbUTtlFApIE
Message-ID: <CANqCtQKpAydgXEzs6OzsDDBM_9yVBaGjT++DBq-NKOUH+ssLGA@mail.gmail.com>
Subject: AT91SAM9261EK kit is broken, commit bd60299 has broken it
From: Remy Bohmer <linux@bohmer.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Christophe,

Currently the Atmel AT91SAM9261-EK kit is broken within Linux 3.0,
3.01 and latest git.

These are the symptoms:
* Booting stops if LCD driver is enabled in the kernel. It stops
within the probe of the LCD driver. (at a msleep(10))
* schedule_timeout is broken.
* The jiffies based sched_clock does not run properly and stalls
during boot, before the LCD driver is being initialised. (You can see
this with printk-timestamps enabled)
* When LCD driver disabled, boards boots up to a prompt, but every
tool (e.g. 'top') that does a nanosleep syscall stays blocked in the
kernel.

After bisecting the tree searching for the offending commit, I came to
the following patch, after reverting it in mainline, everything works
again as normal. I do not see immediately what is wrong with this
commit, do you have an idea? Otherwise I will dig deeper in this
commit...

bd60299594fb1d28ae66563c9e76a0b89b0412cf is the first bad commit
commit bd60299594fb1d28ae66563c9e76a0b89b0412cf
Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date:   Wed Feb 2 07:27:07 2011 +0100

    at91: switch to CLKDEV_LOOKUP

    we do not change the clock naming convention so does not need to switch
    the AVR32 yet

    Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Cc: Patrice Vilchez <patrice.vilchez@atmel.com>

Kind regards,

Remy
