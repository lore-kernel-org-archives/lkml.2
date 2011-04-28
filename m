Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1D1GyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:54:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57332 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1D1GyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:54:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pi5aH85DAsUMu/2eCk2cgJWtm3J6NZXAzvlhU9cqKgBIveGmGNjO32lQzyOMobViTD
         M/cPXpsZGNovdrnpPjhr5htQT+vLlr+Orbs4Yt+DPwprXicVplDP7vbxz3lIqYQqMUut
         +ClKNC64oQQTNP6b+LD4S9Yb8xQZGhWuty4Hs=
MIME-Version: 1.0
In-Reply-To: <20110428105634.7a98c094.sfr@canb.auug.org.au>
References: <20110428105634.7a98c094.sfr@canb.auug.org.au>
Date: Thu, 28 Apr 2011 08:54:04 +0200
X-Google-Sender-Auth: XIm2PpYHHm8vnQpG-RM7VPZbkkY
Message-ID: <BANLkTinJZSh5y3gAa9ZkY1giPwzA7Nni6w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the ux500-core tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/28 Stephen Rothwell <sfr@canb.auug.org.au>:

> After merging the ux500-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/video/via/via-gpio.c:148: error: 'gpio_config' redeclared as different kind of symbol
> include/asm-generic/gpio.h:164: note: previous declaration of 'gpio_config' was here
>
> Caused by commit cf451708d300 ("gpio: add a custom configuration
> mechanism to gpiolib").

Hm! How typical. I will push a patch that renames gpio_config in the
via driver to via_gpio_config so we don't get this namespace clash.

Yours,
Linus Walleij
