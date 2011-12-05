Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1LETpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:45:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52246 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932170Ab1LETps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:45:48 -0500
Date: Mon, 5 Dec 2011 19:45:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111205194545.GH7467@opensource.wolfsonmicro.com>
References: <20111130135847.68a6e4c6@notabene.brown>
 <CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
 <20111201095633.700e2923@notabene.brown>
 <20111130231740.GA25340@opensource.wolfsonmicro.com>
 <20111130232529.GB3220@core.coreip.homeip.net>
 <20111201162144.187ecca3@notabene.brown>
 <20111201113449.GD2915@opensource.wolfsonmicro.com>
 <20111205140413.0d2c5382@notabene.brown>
 <20111205120608.GI11150@opensource.wolfsonmicro.com>
 <20111206063834.3f66b3e0@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206063834.3f66b3e0@notabene.brown>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 06:38:34AM +1100, NeilBrown wrote:

> Ahh..
> So to try to restate the requirements:

>  A "cable-port" can detect when a "cable" in inserted (or removed) and can
>  determine the "cable-type" which comprises:
>    - a "cable-name" which is an arbitrary label interpreted in the context of
>      the particular port
>    - 1 or more "cable-function" flags which indicate what functions the 
>      cable support.  A given port has a fixed set of "cable-functions" and 
>      for any given cable it will report true/false (present/absent, on/off)
>      for each cable-function.
> 
>  This full "cable-type" needs to be presented to user-space, and individual
>  cable-functions may need to be communicated to specific drivers to trigger a
>  'probe' function.

Yes, that seems broadly sane for me.

> Questions:
>   1/ Do we need to communicate anything to drivers apart from "cable-detect"?
>      i.e. are they quite cable of probing and identifying, or do they need to
>      be told what to look for?

Perhaps.

>   2/ Does it hurt to simply wake up all drivers that might be listening on
>      the cable or do we need individual wake-ups (notifiers) for each
>      cable-function?

I suspect not.

>   3/ Does anything in the kernel care about the cable-name, or is that only
>      interesting to user-space?

I suspect not.

Other people may have other opinions, though.
