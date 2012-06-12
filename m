Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2FLLVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:21:06 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:40505 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2FLLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <4FD0D5FF.2000104@wwwdotorg.org>
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
	<4FBCF9F0.1010901@wwwdotorg.org>
	<Pine.LNX.4.64.1205231659310.21980@axis700.grange>
	<4FBD01A6.4080807@wwwdotorg.org>
	<Pine.LNX.4.64.1206070332100.9501@axis700.grange>
	<4FD0D5FF.2000104@wwwdotorg.org>
Date: Tue, 12 Jun 2012 13:21:02 +0200
Message-ID: <CACRpkdZRgCnQktd7Q37Mho2uVWcxY2JS=tqkbFfg3MB5E97xCA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 6:25 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/06/2012 08:05 PM, Guennadi Liakhovetski wrote:

>> Sorry for not mentioning this in my previous reply, but there's more to
>> it, not just data lines can optionally be present. Each of the 3 possible
>> data-bus widths can also have Card Detection and Write Protect lines
>> present, which brings the number of possible configurations to 4 * 3 =
>> 12... We don't want to try all of them, right?

No that seems tiresome. And as noted elsewhere pinctrl is not
about maximum exercise of combinatorics. Nor should you encode
all possible combinations in you map, only put in a "default" map which
applied to that very board.

>> Whereas just querying the
>> pinctrl framework about which pins have been selected and configured seems
>> to be quite straight forward to me. Or should we request several
>> configurations from the driver? One of the 3 bus widthes, and additionally
>> a card-detection and a write-protect configurations?
>
> I would personally recommend not deriving any information from the
> selected pinctrl configuration at all. That way, you /can/ just use a
> "default" state, and never have to search through multiple pinctrl
> states. The board file will define that one state as setting up pinctrl
> however it needs to be for that board - 1/4/8 bit, with/without
> CD/WP/... signals/GPIOs etc.

I second this, if possible.

> If you're using built-in CD/WP logic on the SD host controller and don't
> have the ability to make those pins plain GPIOs, I think it's entirely
> reasonable to require DT to contain properties to enable/disable those
> features, e.g. I see fsl-imx-esdhc.txt already has fsl,cd-internal and
> fsl,wp-internal properties for this purpose.

This looks good to me.

I'm just guessing that the case is such that the SD controller has
built-in lines for CD and WP, but on its way to the external pin it
passes a piece of hardware that has pin configuration capabilities,
and in this case I'm semi-guessing that this piece of hardware
has a mode for that pin/line called "gpio" and that is where all
confusion comes from. But actually that has nothing to do with
the Linux concept of GPIOs (which is just gpiolib and a big
numberspace) as far as Linux is concerned, this is a pin config
setting part of the "default" state and nothing else.

Yours,
Linus Walleij
