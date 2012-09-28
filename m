Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2I1Aa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:30:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49523 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab2I1Aa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAGhQ9VzJtx3MJF1wdJd8hv7Hp4T0YJK=vNbJWGj_W7X+mLy-xQ@mail.gmail.com>
References: <20120818145856.GP18957@n2100.arm.linux.org.uk>
	<CACVXFVPahbFVEP4p2Z9-TvjQ52tUCMuDeLx0X6GP5t0h5gEV8g@mail.gmail.com>
	<20120916082510.GN12245@n2100.arm.linux.org.uk>
	<CACVXFVOZ=4HFAy38q_8ZUjOPffcv_mMTi7KCdh3HcX=MCLw5SQ@mail.gmail.com>
	<20120926200833.GA14340@kroah.com>
	<20120926202321.GD30938@n2100.arm.linux.org.uk>
	<CACVXFVPnpQ6yHiDaoo_CPG7oSEq+ZzxpmTgQv55-tRRyaavDfA@mail.gmail.com>
	<20120927135809.GE14358@n2100.arm.linux.org.uk>
	<20120927140300.GF14358@n2100.arm.linux.org.uk>
	<CAGhQ9VzJtx3MJF1wdJd8hv7Hp4T0YJK=vNbJWGj_W7X+mLy-xQ@mail.gmail.com>
Date: Fri, 28 Sep 2012 08:30:55 +0800
Message-ID: <CACVXFVO5hChrEqK=mS1i7R0hbCfg6SZfuBkB7j+zKf3xj-JGRg@mail.gmail.com>
Subject: Re: [BUG] Deferred probing in driver model is racy, resulting in lost probes
From: Ming Lei <tom.leiming@gmail.com>
To: Joachim Eastwood <manabian@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 1:22 AM, Joachim  Eastwood <manabian@gmail.com> wrote:

>
> I am also having problems with ASoC modules and deferred probing. This
> patch seems to improve the a lot situation, though. Now it work most
> of the time, but occasionally I get the warning below.
>
> Not sure if this is directly related to the issue Russell have been
> seeing. Guess it can be races in the Atmel ASoC drivers as well(?).

Looks the driver involved is out of tree since mpa1600_audio_probe
can't be found in -next or linux tree.

Also your problem should be related the driver and probably caused
by calling atmel_ssc_set_audio more than one time.

Thanks,
-- 
Ming Lei
