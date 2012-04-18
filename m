Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab2DRRhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:37:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56818 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab2DRRhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:37:12 -0400
Message-ID: <4F8EFBC5.1030607@wwwdotorg.org>
Date: Wed, 18 Apr 2012 11:37:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Dong Aisheng <aisheng.dong@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] pinctrl: handle dummy state in core
References: <1334586289-13078-1-git-send-email-b29396@freescale.com>	<4F8C42D6.2000607@wwwdotorg.org>	<20120417034210.GD17173@shlinux2.ap.freescale.net>	<CACRpkdYH06_kGbSdozKPWZcOG0FvoOyHvjHwhz-xUL1pfSX9DQ@mail.gmail.com>	<20120418122832.GP20478@pengutronix.de> <CACRpkdZw6iv=PjvvU4s5L8yV6813gCD7t8Vk-S66v-nXPaf+=Q@mail.gmail.com>
In-Reply-To: <CACRpkdZw6iv=PjvvU4s5L8yV6813gCD7t8Vk-S66v-nXPaf+=Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 07:52 AM, Linus Walleij wrote:
> On Wed, Apr 18, 2012 at 2:28 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
>> Currently Dong Aisheng is working on i.MX6, we have i.MX31, i.MX35,
>> i.MX51 and i.MX53 enabled in the same defconfig. Waiting for all
>> machines turn over at once to pinctrl is illusionary. We have to make
>> drivers work with and without pinctrl. We have a bunch of bad choices:
>>
>> - create a dummy pinctrl for all boards which do not have real pinmux
>>  support
> 
> Viable compromise.
> 
>> - ignore pinctrl_request errors in drivers.
> 
> Ugh. Not good.
> 
>> - generate and return a dummy pinctrl in the core if no real pinctrl is
>>  found.
>>
>> (replace pinctrl with regulators or clocks, it's the same situation, and
>> it's not only i.MX specific)
> 
> Since we have dummy regulators, we should not break the design
> pattern creating more confusion.
> 
> Stephen can you live with dummy pinctrl handles emitted by the
> core, if explicitly enabled by a Kconfig option?

Yes, I'm happy with the pinctrl core having the ability to "magically"
work when the dummy mapping table entries (or DT entries) are missing,
so long as there is a default-off Kconfig or runtime option that enables
that feature, which I'd expect to be use only for boards/platforms/...
that are "under conversion".
