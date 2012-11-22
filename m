Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab2KVXGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:06:09 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56346 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2KVS2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:28:32 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaNmBpfONDpt7zFqLaqfiGm+ELpO-v5gZmM0rEi_AzijQ@mail.gmail.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost>
 <20121121013133.GE4673@opensource.wolfsonmicro.com> <CACRpkdaNmBpfONDpt7zFqLaqfiGm+ELpO-v5gZmM0rEi_AzijQ@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 22 Nov 2012 18:55:16 +0900
Message-ID: <CAAVeFuLL28y89VGU4EfPdW-fKDZCFnyQ37UdhGpeZE3cn0Cbzg@mail.gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Ola LILJA2 <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 5:57 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> I have the same (limited by experience) opinion. Working sort of
> near som audio drivers I have understood that power sequencing
> is a big issue not only for things like this backlight example, but
> even more so in the area of audio to avoid clicks and pops.
>
> Is it correct to assume that this library will be useful also for ALSA
> SoC type of devices?

There should be nothing against that - provided ALSA's needs remain
similar to the current set of actions (regulators, gpios, ...) it
should be perfectly usable. Can you think of any usage that involves
more than dumb regulator/gpio manipulation?

If power seqs are to be used this way (as opposed to through the DT),
it will become urgent to implement that gpio handlers library we were
talking about in another thread, as we don't want to have GPIO numbers
hard-coded into the sequences.

Alex.
