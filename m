Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab2LLWV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:21:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59037 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab2LLWV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:21:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] drivers/pinctrl: grab default handles from device core
Date: Wed, 12 Dec 2012 23:26:59 +0100
Message-ID: <10768446.F2JLuVrZNU@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CACRpkdbCuTAwqFVWkb7bx7_OAX_0PU8TjjbS879Ui30bdxXkQg@mail.gmail.com>
References: <1355233246-16694-1-git-send-email-linus.walleij@stericsson.com> <20121211181336.GD25714@kroah.com> <CACRpkdbCuTAwqFVWkb7bx7_OAX_0PU8TjjbS879Ui30bdxXkQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 12, 2012 08:56:41 PM Linus Walleij wrote:
> On Tue, Dec 11, 2012 at 7:13 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Dec 11, 2012 at 02:40:46PM +0100, Linus Walleij wrote:
> >> diff --git a/include/linux/device.h b/include/linux/device.h
> 
> >> +#ifdef CONFIG_PINCTRL
> >> +     struct dev_pin_info     pins;
> >> +#endif
> >
> > Can't you just make this a * to the structure, saving a bit of space for
> > those that don't use this structure?  Ok, it's only saving one pointer,
> > so it's really not a big deal to me if you don't want to do this, just
> > asking...
> 
> OK I'll look into it.

I wonder if you could use a struct that will be empty if CONFIG_PINCTRL is
unset instead of using #ifdef around the field like this?  [Kind of along the
lines of what I did for ACPI.]

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
