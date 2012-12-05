Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2LEKtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:49:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39454 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2LEKtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:49:39 -0500
From: Florian Fainelli <florian@openwrt.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, JM.Lin@atmel.com, wim@iguana.be,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 2/8] watchdog/at91sam9_wdt: Convert to use the watchdog framework
Date: Wed, 05 Dec 2012 11:47:39 +0100
Message-ID: <3976223.KImVV2lC5B@flexo>
Organization: OpenWrt
User-Agent: KMail/4.9.2 (Linux/3.5.0-17-generic; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1354671267-19277-3-git-send-email-wenyou.yang@atmel.com>
References: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com> <1354671267-19277-3-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wenyou,

On Wednesday 05 December 2012 09:34:21 Wenyou Yang wrote:
> According to the kernel document: convert_drivers_to_kernel_api.txt,
> remove the file_operations struct, miscdevice, and obsolete includes
> 
> Since the at91sam watchdog inherent characteristics, add the watchdog
> operations: at91wdt_start, at91wdt_stop and at91wdt_ping.
> 

[snip]

>  
> +static inline bool watchdog_is_open(struct watchdog_device *wddev)
> +{
> +	return test_bit(WDOG_DEV_OPEN, &wddev->status);
> +}

This helper should be moved to include/linux/watchdog.h as it can be useful
for other watchdog drivers as well. 
--
Florian
