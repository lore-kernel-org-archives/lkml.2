Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2DXIXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:23:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56832 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2DXIXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120416033519.GA17173@shlinux2.ap.freescale.net>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
	<1334333915-1174-3-git-send-email-b29396@freescale.com>
	<20120414135331.GB3852@pengutronix.de>
	<CAA+hA=QhSUZg0bWTss_4ROwZ--OOQfcP=mpt+MP7-ZKPkEwXyA@mail.gmail.com>
	<20120415073751.GF24997@S2101-09.ap.freescale.net>
	<20120416033519.GA17173@shlinux2.ap.freescale.net>
Date: Tue, 24 Apr 2012 10:23:34 +0200
Message-ID: <CACRpkdZWNNz3+LbPtkV4rS4BJpqQdZio0qLkedLamSisgDkm6Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: imx6q: switch to use pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <dongas86@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 5:35 AM, Dong Aisheng
<aisheng.dong@freescale.com> wrote:
> On Sun, Apr 15, 2012 at 03:37:54PM +0800, Shawn Guo wrote:
>> On Sun, Apr 15, 2012 at 12:03:16PM +0800, Dong Aisheng wrote:
>> ...
>> > For MX3 and MX5, before their pinctrl driver are available, user may
>> > need to define a dummy in dt to avoid such an error.
>> >
>> That is insane, and will not work.
>>
>> 1) We do not have device tree support for MX3 yet.
>> 2) It's not practical to add dummy entries in dt to avoid the error.
>> 3) There are still so many non-dt board files support in the tree.
>> How will they work with that?
>>
>> My suggestion is to not make it an error but a dev_dbg, assuming that
>> the pins are already set up by platform code if we do not find the
>> entry from pinctrl system.  We can take it as a transition solution,
>> and turn the dev_dbg back to error when all the users of the device
>> driver are converted to device tree.
>>
> My thinking is let pinctrl core handle dummy state as regulator subsystem
> and does not depend on dt.
> Linus, Stephen, any comment?

I think this was discussed in another thread and Sascha agreed that
wee need dummy pinctrl to copy with a smooth transition in i.MX.

So I'm happy with that, we just need to finalize a patch, poke
me if I missed some patch...

Yours,
Linus Walleij
