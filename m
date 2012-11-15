Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767901Ab2KOODq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:03:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57171 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767872Ab2KOODn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:03:43 -0500
MIME-Version: 1.0
In-Reply-To: <20121113063546.GD18224@opensource.wolfsonmicro.com>
References: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com>
	<50A15A54.3090803@wwwdotorg.org>
	<20121113063546.GD18224@opensource.wolfsonmicro.com>
Date: Thu, 15 Nov 2012 15:03:40 +0100
Message-ID: <CACRpkdY-tye5LNOwxQ-XrjM-x9RffAvj-tPfsFQA3ZWOY8P-Vw@mail.gmail.com>
Subject: Re: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 7:35 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Nov 12, 2012 at 01:21:40PM -0700, Stephen Warren wrote:
>> On 11/11/2012 05:22 AM, Linus Walleij wrote:
>
>> > Another solution that was discussed was whether to move
>> > the default pinctrl handle and state grab to the device
>> > core as an optional field in struct device itself, but
>> > I'd like to first propose this less intrusive mechanism.
>
>> I think doing that approach makes a lot more sense; wouldn't it
>> completely avoid the issues with deferred probe that this notifier-based
>> method can't solve? It would also be very much in line with e.g.
>> dev_get_regmap() - if every resource that a driver required were handled
>> like that, then deferred probe could be significantly isolated into the
>> driver core rather than in every driver...
>
> I have to say that I agree with this, notifiers seem to make life more
> complicated for limited gain.  Otherwise I guess we could enhance
> notifiers so that they're able to trigger deferrals?

OK I'll have to come up with a patch to the device core
instead... it'll be much simpler anyway and if both of you guys
can back it I guess Greg might be OK with it too.

Yours,
Linus Walleij
