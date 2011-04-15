Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1DOVG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:06:57 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59110 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab1DOVG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:06:56 -0400
References: <1302816996-6345-1-git-send-email-natg@google.com>
In-Reply-To: <1302816996-6345-1-git-send-email-natg@google.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <25810A23-EB28-4FBF-8CEB-487313F0E16E@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>, Mike Waychison <mikew@google.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        =?iso-8859-1?Q?=22Juan_Jes=FAs_Garc=EDa_de_Soria=22?= 
	<skandalfo@gmail.com>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: [PATCH v6 0/2] Make all it87 drivers SMP safe
Date: Fri, 15 Apr 2011 17:07:03 -0400
To: Nat Gurumoorthy <natg@google.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 14, 2011, at 5:36 PM, Nat Gurumoorthy wrote:

> There are 3 different drivers that touch the it87 hardware registers.
> The 3 drivers have been written independently and access the it87 hardware
> registers assuming they are the only driver accessing it. This change
> attempts to serialize access to the hardware by using
> "request_muxed_region" macro defined by Alan Cox. Call to this macro
> will hold off the requestor if the resource is currently busy.
> The use of the above macro makes it possible to get rid of
> spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
> This also greatly simplifies the implementation of it87_wdt.c driver.
> 
> 01 - Changes to it87 watchdog driver to use "request_muxed_region"
> drivers/watchdog/it8712f_wdt.c
> drivers/watchdog/it87_wdt.c
> 
> 02 - Chages to hwmon it87 driver to use "request_muxed_region"
> drivers/hwmon/it87.c
> 
> drivers/hwmon/it87.c           |   30 +++++++++++++-
> drivers/watchdog/it8712f_wdt.c |   50 +++++++++++++++++++++---
> drivers/watchdog/it87_wdt.c    |   80 +++++++++++++++++++++------------------
> 3 files changed, 113 insertions(+), 47 deletions(-)

FYI,

$ head -n 4 drivers/media/rc/ite-cir.c
/*
 * Driver for ITE Tech Inc. IT8712F/IT8512 CIR
 *
 * Copyright (C) 2010 Juan Jesús García de Soria <skandalfo@gmail.com>


-- 
Jarod Wilson
jarod@wilsonet.com



