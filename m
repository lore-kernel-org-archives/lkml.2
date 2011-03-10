Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1CJPnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:43:52 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36922 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1CJPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:43:51 -0500
MIME-Version: 1.0
In-Reply-To: <20110310134953.GE22195@opensource.wolfsonmicro.com>
References: <1299764621-2532-1-git-send-email-linus.walleij@stericsson.com>
	<20110310134953.GE22195@opensource.wolfsonmicro.com>
Date: Thu, 10 Mar 2011 16:43:50 +0100
Message-ID: <AANLkTim5Qw_PQJ234YsNvvmsg7L-RGfTsuMaTHvUmLHK@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: add ab8500 per-regulator startup delay
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 2:49 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Mar 10, 2011 at 02:43:41PM +0100, Linus Walleij wrote:
>> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>>
>> Since some regulators can take some time to come online, we
>> define a per-regulator millisecond delay value and assign
>> to the slow TV-out regulator.
>
> You should be implementing the enable_time() operation for the regulator
> for this.

I looked into it, but the core implicitly only does delays after
enable(), and our delays affect disable() and set_voltage()
as well. disable() may look superfluous but I bet there may be
cases where not having a voltage fully disabled before doing
something will cause immesurable harm.

I was thinking about extending the present mechanism in
core by refactoring the signature of the enable_time()
as such:

/* Operations that we want to enumerate to the enable_time() call */
enum regulator_op {
     REGULATOR_ENABLE,
     REGULATOR_DISABLE,
     REGULATOR_SET_VOLTAGE,
     REGULATOR_SET_MODE,
};

/* Time taken to enable the regulator */
int (*enable_time) (struct regulator_dev *, enum regulator_op op);

Then I'll have to break out the delay code and refactor a bit,
altering the few drivers using it I guess.

Sounds like a plan?

Yours,
Linus Walleij
