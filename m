Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2ABLqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:46:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2ABLqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:46:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAN1soZwEj2SYa9eqH-Nyw0wvVF8kk7tn_gLu+BPDS3ZT1Has+Q@mail.gmail.com>
References: <1324249593-3051-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF176BE92C1B@HQMAIL01.nvidia.com>
	<CAN1soZwEj2SYa9eqH-Nyw0wvVF8kk7tn_gLu+BPDS3ZT1Has+Q@mail.gmail.com>
Date: Mon, 2 Jan 2012 12:46:29 +0100
Message-ID: <CACRpkdbYEbmrg+-uKn3VREe6GrKOL0urPXDFf21GZfM5fQPcUA@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: add support for group and pinmux states
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 3:22 AM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:

> Do we really need to configure low power mode in device driver?

Who said anything about the device driver?

It's just an API, I was imagining the group states being triggered
from where it makes sense. In our case it would currently be done
in the central system-wide runtime PM and system idle loop. Not
in device drivers at all.

> In most time,
> user will set and tune the low power mode of pins.
>
> If the low power setting
> could be configured via sysfs, it could save a lot of time to rebuild kernel.

pinctrl does not have a sysfs interface, and as per discussion with
Grant this needs to be designed with care. I think proper device nodes
for the pin controllers and iopctl():s is way more apropriate if we really
want a userspace interface to pinctrl stuff.

> Especially GPIO pins are board specific. I think that configure all low power
> setting in board specific code is more reasonable.

As outlined in my response to Stephen you supply the group states
to your driver along with any other platform data or DT nodes.

Yours,
Linus Walleij
