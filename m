Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2EPFkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:40:36 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:50132 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255Ab2EPFke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:40:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120516002500.GD29393@b20223-02.ap.freescale.net>
References: <1336798797-8724-1-git-send-email-skannan@codeaurora.org>
 <1337114622-11292-1-git-send-email-skannan@codeaurora.org> <20120516002500.GD29393@b20223-02.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Tue, 15 May 2012 22:40:11 -0700
Message-ID: <CAJOA=zP4kS1CPry5nWo-mTba+9dAdK_a+rUrNCkQrzgixa3kRg@mail.gmail.com>
Subject: Re: [PATCH] clk: Fix CLK_SET_RATE_GATE flag validation in clk_set_rate().
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 5:25 PM, Richard Zhao
<richard.zhao@freescale.com> wrote:
> On Tue, May 15, 2012 at 01:43:42PM -0700, Saravana Kannan wrote:
>> The clk_set_rate() code shouldn't check the clock's enable count when
>> validating CLK_SET_RATE_GATE flag since the enable count could change after
>> the validation. Similar to clk_set_parent(), it should instead check the
>> prepare count. The prepare count should go to zero only when the end user
>> expects the clock to not be enabled in the future. Since the code already
>> grabs the prepare count before validation, it's not possible for prepare
>> count to change after validation and by association not possible for a well
>> behaving end user to enable the clock while the set rate is in progress.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> Reviewed-by: Richard Zhao <richard.zhao@freescale.com>

Looks good to me.  I'll take into clk-next for one final pull request
to arm-soc.

Thanks,
Mike
