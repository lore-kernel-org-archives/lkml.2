Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2EMQbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:31:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55495 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2EMQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:31:01 -0400
Message-ID: <4FAFE1BF.9050805@googlemail.com>
Date: Sun, 13 May 2012 18:30:55 +0200
From: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
References: <4FAB15DB.5050702@googlemail.com> <20120513122946.GD706@sirena.org.uk>
In-Reply-To: <20120513122946.GD706@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2012 02:29 PM, Mark Brown wrote:
> Always CC maintainers on mails, things get lost on high volume lists.

Yeah, right after posting I thought of this but didn't want to bother
you again. I read a lot of kernel code since then and some things are
much more clearer to me now. Besides the driver is almost done now and
works as expected. Will have to clean up things and will post it as
a patch then.

> I'd suggest using regmap for the cache support (which helps with
> read/modify/write cycles) and because...

I will have a look at regmap before I post a new driver patch for
sure.

>> static const struct clk_ops si5351_xtal_ops = {
>> 	.enable = si5351_xtal_enable,
>> 	.disable = si5351_xtal_disable,
>
> These should be prepare() and unprepare() - enable() and disable() are
> called from atomic context so you can't do I2C I/O.

You are right. The kernel code states this correctly and I should have
read it more carefully.

>> static u8 si5351_clkout_get_parent(struct clk_hw *hw)
>> {
>> 	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
>> 	return 0;
>> }
>
> If we need empty functions like this we should fix the framework.

Of course, this function is not empty at all but wasn't done at the
time I posted the RFC.

One question that remains from my original RFC is the missing
clk_unregister() as i2c can be removed there also should be an
function to unregister previously registered clocks?

Sebastian
