Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1LTBBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:01:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48717 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704Ab1LTBBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:01:14 -0500
Date: Tue, 20 Dec 2011 01:01:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>
Subject: Re: [PATCH v2 0/3] introduce External Connector Class (extcon)
Message-ID: <20111220010109.GO2860@opensource.wolfsonmicro.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
 <20111215133229.20e7f0f2@notabene.brown>
 <20111215065154.GA24248@opensource.wolfsonmicro.com>
 <20111218181550.3fd35f6c@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111218181550.3fd35f6c@notabene.brown>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 06:15:50PM +1100, NeilBrown wrote:
> On Thu, 15 Dec 2011 14:51:55 +0800 Mark Brown

> > Grant has a proposal for this which revolves around devices trying to
> > acquire their resources and returning a "please retry" error code if
> > they don't have all their dependencies.  Half the problem here is that

> A possibility I have been thinking about is to multithread do_initcalls() and
> have the various request functions (gpio_request, regulator_get, request_irq,
> etc) optionally block if the resource isn't available.

That seems to be logically the same in terms of what it actually does
but introduces concurrency which wasn't there before which means that
things could get reordered for random reasons.  That seems like it'd not
be great for robustness.

> Do we need to talk about devices that haven't been enumerated yet? or was
> that just if we wanted to create an explicit dependency graph?

You need to know about devices that aren't enumerated yet.
