Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1C2Ivo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:51:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54858 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1C2Ivn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=W/gisu26WrKYbo7J7Jz4pIa8xjxNX7M89/SN+YFy0PjQ0NfDkOElcMTqa6tu22Hi36
         qQm64/NbT3dzqN2reQ7oYTudBTuFefM5BdGk0BqKX8/pGMvRZ5/kpYy342ZUX8YRYk/v
         I2U39JnYtx/1jMEKz6ATdWmyT3ybOjMpnRUs8=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] s3c2440: mini2440: Enable the backlight LED earlier at boot time.
Date: Tue, 29 Mar 2011 11:50:31 +0300
User-Agent: KMail/1.13.6 (Linux/2.6.38-gentoo-anarsoul; KDE/4.6.1; i686; ; )
Cc: Marek Belisko <marek.belisko@open-nandra.com>, ben-linux@fluff.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, buserror@gmail.com, esta1ien@gmail.com
References: <1301380363-3282-1-git-send-email-marek.belisko@open-nandra.com> <1301380363-3282-5-git-send-email-marek.belisko@open-nandra.com>
In-Reply-To: <1301380363-3282-5-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291150.32097.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011 09:32:43 Marek Belisko wrote:
> Code overtaken from:
> http://repo.or.cz/w/linux-2.6/mini2440.git
> 
> Use flag that allows s3c24xx LED to start in the "on" state.
> This is necesary to enable LCD backlight during early boot stage.

Why are you still using leds-s3c24xx driver? mini2440 should work OK with 
leds-gpio. Anyway, looks like patch should be splitted into 2 patches: first 
adds flag to leds-s3c24xx driver, second enables this flag for mini2440.

Regards
Vasily

> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> Signed-off-by: Michel Pollet <buserror@gmail.com>
> ---
>  arch/arm/mach-s3c2410/include/mach/leds-gpio.h |    1 +
>  arch/arm/mach-s3c2440/mach-mini2440.c          |    1 +
>  drivers/leds/leds-s3c24xx.c                    |    6 +++++-
>  3 files changed, 7 insertions(+), 1 deletions(-)
