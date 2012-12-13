Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2LMLze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:55:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41900 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2LMLzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:55:31 -0500
Date: Thu, 13 Dec 2012 11:55:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: Re: [PATCH 01/12] regulator: gpio-regulator: Demote GPIO Regulator
 driver to start later
Message-ID: <20121213115524.GI27617@gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-2-git-send-email-lee.jones@linaro.org>
 <20121210140751.GB6103@opensource.wolfsonmicro.com>
 <20121210142836.GG9362@gmail.com>
 <20121210143141.GG6103@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121210143141.GG6103@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012, Mark Brown wrote:

> On Mon, Dec 10, 2012 at 02:28:36PM +0000, Lee Jones wrote:
> > On Mon, 10 Dec 2012, Mark Brown wrote:
> 
> > > This really isn't a good solution, especially not for a system that's DT
> > > based - on a DT system we can tell if there should be a GPIO present so
> > > we should be able to defer only when there's something that might
> > > provide the GPIO later on.
> 
> > Understood, but what's the solution for non-DT systems?
> 
> Provide a fixed regulator or something, perhaps we need a "definitely
> does not exist" regulator to help with this.  For every board you help
> with a sequencing bodge you're probably going to break another that
> needs different sequencing; for that matter it's not like GPIO
> controlled regulators are exclusively used for MMC, or that MMC
> exclusively uses GPIO - doing this for only one regulator is a bit of a
> red flag.

I understand your logic, hence why I wrote such a lengthy commit
message. However, I'm not sure I see a logical way around it. Asking
all users of MMCI to provide a not-regulator to declare that a
secondary regulator isn't available seems a little unreasonable to me.

Is there anything else we can do?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog 
