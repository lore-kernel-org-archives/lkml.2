Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1LEKwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:52:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41241 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825Ab1LEKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:52:05 -0500
Date: Mon, 5 Dec 2011 10:52:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Kyungmin Park <kmpark@infradead.org>, rpurdie@rpsys.net,
        ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH] backlight: add regulator support for platform_lcd driver
Message-ID: <20111205105201.GD11150@opensource.wolfsonmicro.com>
References: <1323074921-29291-1-git-send-email-thomas.abraham@linaro.org>
 <CAH9JG2XJ4TCEaN1rMRjMZNRn5Wx6jcTRC_DmyN4Qyf2zztWSsg@mail.gmail.com>
 <CAJuYYwTT2jbbquZM=ZwK=Gh39ss=iG0WDCc3TYjzHLEgfeC1gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuYYwTT2jbbquZM=ZwK=Gh39ss=iG0WDCc3TYjzHLEgfeC1gA@mail.gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 04:06:17PM +0530, Thomas Abraham wrote:
> On 5 December 2011 15:40, Kyungmin Park <kmpark@infradead.org> wrote:

> > Recent regulator discussion. it should be failed instead fall through
> > gracefully.

> Ok. But in this case, there could be boards that do not use a
> regulator for the lcd/display interface. Is it mandatory for fail if
> regulator is not found. Sorry, I have not read through the regulator
> discussion.

The boards should supply a fixed voltage regulator representing the
supply (or use CONFIG_REGULATOR_DUMMY to substitute in a dummy regulator
when not needed).  Sascha Hauer had some patches to add a flag that
could be set to enable this mode on init rather than through Kconfig but
they needed a bit of cleanup, not sure what the status is there.

> The constraint 'apply_uV' cannot be expressed with a device tree. So
> there has be a mechanism to set the required output voltage for a
> regulator.

It's not an option to not have it with device tree - if there's a single
voltage specified apply_uV is assumed.
