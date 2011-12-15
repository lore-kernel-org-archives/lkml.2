Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1LOGwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:52:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42610 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844Ab1LOGwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:52:01 -0500
Date: Thu, 15 Dec 2011 14:51:55 +0800
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
Message-ID: <20111215065154.GA24248@opensource.wolfsonmicro.com>
References: <1323858508-27198-1-git-send-email-myungjoo.ham@samsung.com>
 <20111215133229.20e7f0f2@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215133229.20e7f0f2@notabene.brown>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 01:32:29PM +1100, NeilBrown wrote:

j> 3/ The use of extcon_get_extcon_dev() requires that the port device be
>    registered before the device that wants to be notified by it.  Ensuring
>    correct ordering of device discovery is (I believe) not always easy -
>    particularly with module loading.

This is a massive problem throughout the kernel 

>    Would it make sense to instead have one device register as a
>    switch-provider and the other device register as a switch-listener and as
>    soon as they both exist they get connected: a bit like how 'devices' and
>    'drivers' can be registered in any order.
>    Maybe the same device/driver infrastructure could be reused (an extcon
>    bus maybe?) but I'm not really familiar enough with it to say (Greg??).

Grant has a proposal for this which revolves around devices trying to
acquire their resources and returning a "please retry" error code if
they don't have all their dependencies.  Half the problem here is that
coming up with the dependency graph (and finding ways to talk about
devices that haven't been enumerated yet) is a very hard problem.

>    Are there other examples of inter-device dependencies that can be used as
>    a model?

The current solution is to fiddle with initcall order so that drivers
for devices that other devices depend on enumerate first.
