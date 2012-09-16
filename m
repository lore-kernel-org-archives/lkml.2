Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2IPJJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 05:09:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43892 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2IPJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 05:09:16 -0400
Message-ID: <50559737.8000705@gmail.com>
Date: Sun, 16 Sep 2012 11:09:11 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 03/10] pinctrl: mvebu: kirkwood pinctrl driver
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347550912-18021-4-git-send-email-sebastian.hesselbarth@gmail.com> <20120916074652.GM28177@lunn.ch>
In-Reply-To: <20120916074652.GM28177@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2012 09:46 AM, Andrew Lunn wrote:
>> +Required properties:
>> +- compatible: "marvell,88f6180-pinctrl",
>> +              "marvell,88f6190-pinctrl", "marvell,88f6192-pinctrl",
>> +              "marvell,88f6281-pinctrl", "marvell,88f6282-pinctrl"
>> +
>> +This driver supports all kirkwood variants, i.e. 88f6180, 88f619x, and 88f628
>
> The current MPP code determines for itself what chip it is running on.
> It can then check if a pin configuration is valid for the current
> run time environment.
>
> Here you are suggesting we have to put into the DT what chip we expect
> to be on.
>
> What is the advantage of this, over getting the information from the
> device itself?

Hi Andrew,

there is no advantage over determining the variant on run time except
that it is statically and (normally) known at boot time. I understand
that mass converting kirkwood to pinctrl would require to know all
the different variants.

If there are no objections from the others, I agree to determine the
variant from the existing kirkwood_id(). I was just unsure if it is
ok to use platform-specific code with DT here.

Any ideas how to get kirkwood_id() linked into pinctrl-kirkwood with
the get-rid-of-arch-includes policy?

Sebastian
