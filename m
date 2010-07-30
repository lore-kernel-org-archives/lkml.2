Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0G3P7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 11:59:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39611 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab0G3P7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 11:59:52 -0400
Message-ID: <4C52F6C1.5090207@mvista.com>
Date: Fri, 30 Jul 2010 19:58:57 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        Nicolas Pitre <nico@marvell.com>, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] MTD: pxa2xx: move pxa2xx_flash_probe to .devinit.text
References: <1280504530-31737-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1280504530-31737-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König wrote:

> This fixes the following warning by modpost:

> 	WARNING: vmlinux.o(.data+0x15018): Section mismatch in reference from the variable pxa2xx_flash_driver to the function .init.text:pxa2xx_flash_probe()
> 	The variable pxa2xx_flash_driver references
> 	the function __init pxa2xx_flash_probe()
> 	If the reference is valid then annotate the
> 	variable with __init* or __refdata (see linux/init.h) or name the variable:
> 	*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

> I choosed to do this instead of using platform_driver_probe as the remove

    s/choosed/chose/

> function uses __devexit.

    Perhaps remove() method should have been fixed instead -- I doubt that 
this is a hotplug device.

WBR, Sergei

