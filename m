Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2LJO2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:28:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63720 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2LJO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:28:41 -0500
Date: Mon, 10 Dec 2012 14:28:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: Re: [PATCH 01/12] regulator: gpio-regulator: Demote GPIO Regulator
 driver to start later
Message-ID: <20121210142836.GG9362@gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-2-git-send-email-lee.jones@linaro.org>
 <20121210140751.GB6103@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121210140751.GB6103@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012, Mark Brown wrote:

> On Mon, Dec 10, 2012 at 08:55:50AM +0000, Lee Jones wrote:
> 
> > The normal course of action would be to defer the MMCI driver too,
> > but these IOS level-shifter regulators aren't present on all
> > platforms, so deferring until one is found would be incorrect.
> 
> > So the best solution is to demote the GPIO Regulator driver, so
> > it starts later than the TC35892 GPIO controller, which is also
> > configured to start at subsys_initcall() time, but before deferred
> > probing time, which starts at late_initcall(), after many of the
> > drivers requiring these regulators would have already started.
> 
> This really isn't a good solution, especially not for a system that's DT
> based - on a DT system we can tell if there should be a GPIO present so
> we should be able to defer only when there's something that might
> provide the GPIO later on.

Understood, but what's the solution for non-DT systems?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
