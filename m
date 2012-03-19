Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab2CSTd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:33:29 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47014 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965127Ab2CSTd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <4F678561.3040105@codeaurora.org>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org> <4F6404C2.7000506@codeaurora.org>
 <CAJOA=zP1HHqBNS4V2dN=Q9oOcOErQj8W__fB_qRyZeNLBk7VJg@mail.gmail.com> <4F678561.3040105@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 19 Mar 2012 12:33:05 -0700
Message-ID: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 12:13 PM, Saravana Kannan
<skannan@codeaurora.org> wrote:
> I saw some responses from you over the weekend but not to mine. So, I
> assumed you were busy with other stuff and I started working on a patch on
> top of v7.

I only answer trivial emails on the weekend ;-)

> I will send that out if I get around to finishing it before you
> do. Hope that's alright with you.

I'm happy to for you to take a crack at it.  I don't know what your
implementation looks like, but here are a couple concerns I have:

1) if you're copying the data from the initializer over to the struct
clk then make sure you handle the __init data aspects of it properly

2) are the members of struct clk_hw visible to the rest of the world?
Are they modifiable (i.e., not const)?  This is undesirable.

Thanks,
Mike
