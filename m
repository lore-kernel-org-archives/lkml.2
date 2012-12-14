Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab2LNCqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:46:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58249 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410Ab2LNCql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:46:41 -0500
Date: Fri, 14 Dec 2012 11:46:28 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org
Subject: Re: [PATCH 02/12] regulator: gpio-regulator: Only read GPIO
 [dis|en]able pin if not always-on
Message-ID: <20121214024626.GA4478@opensource.wolfsonmicro.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
 <1355129761-8088-3-git-send-email-lee.jones@linaro.org>
 <20121210141000.GC6103@opensource.wolfsonmicro.com>
 <20121213114818.GH27617@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213114818.GH27617@gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 11:48:18AM +0000, Lee Jones wrote:
> On Mon, 10 Dec 2012, Mark Brown wrote:
> > On Mon, Dec 10, 2012 at 08:55:51AM +0000, Lee Jones wrote:
> > > If a regulator is specified as always-on, then it can't have an
> > > enable/disable pin, as it can't be turned off.

> > Sometimes always on gets set for regulators which do have a physical
> > control wired up - the control might exist for use in suspend mode for
> > example.  Is the ability to specify an enable pin causing a practical
> > problem for systems?  If it is we should fix that.

> My logic is that there is no point in requesting a pin which can
> disable a regulator that can't be disabled. Then we can follow
> on from that logic and say that if a regulator is _not_ always on
> this we _require_ a way to disable it, thus we insist on an enable
> GPIO pin.

> With me?

No.  Making the enable pin optional for always on regulators is fine,
forbidding it is not - that won't work for things like the suspend case
I mentioned.
