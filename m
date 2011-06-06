Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1FFISu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 04:18:50 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:32993 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1FFISt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 04:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110606081205.GC32632@pengutronix.de>
References: <1307290075-7062-1-git-send-email-shawn.guo@linaro.org>
 <1307290075-7062-3-git-send-email-shawn.guo@linaro.org> <20110606075241.GD10410@ponder.secretlab.ca>
 <20110606081205.GC32632@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 02:18:29 -0600
X-Google-Sender-Auth: m2YPXrmY8LbFMunDEuEwREHYAYs
Message-ID: <BANLkTinY44trVnt-XXaH85Vsj46put6N1Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] gpio/mxc: Change gpio-mxc into an upstanding gpio driver
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, arnd@arndb.de, patches@linaro.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 2:12 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, Jun 06, 2011 at 01:52:41AM -0600, Grant Likely wrote:
>> On Mon, Jun 06, 2011 at 12:07:55AM +0800, Shawn Guo wrote:
>> > The patch makes necessary changes on gpio-mxc as below to turn it
>> > into an upstanding gpio driver.
>> >
>> >  * Add a list to save all mx2 ports references, so that
>> >    mx2_gpio_irq_handler can walk through all interrupt status
>> >    registers
>> >
>> >  * Use readl/writel to replace mach-specific accessors
>> >    __raw_readl/__raw_writel
>> >
>> >  * Change mxc_gpio_init into mxc_gpio_probe function
>> >
>> >  * Move "struct mxc_gpio_port" into gpio-mxc.c, as it needs not to
>> >    be public at all, and also make some other cleanup on
>> >    plat-mxc/include/mach/gpio.h at the same time
>> >
>> > And the patch then migrates mach-imx and mach-mx5 to the updated
>> > driver by adding corresponding platform devices.
>> >
>> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>> > Acked-by: Olof Johansson <olof@lixom.net>
>>
>> Applied, thanks.
>
> I'm not completely happy with this patch going through your tree. It
> does massive changes to arch/arm/mach-*mx*, so expect merge conflicts
> here.

There are also massive changes going on in drivers/gpio.  The solution
here is to probably put these changes into a new dedicated branch
based on Linus' tree, we both agree not to rebase that branch, and
both of us merge the branch into our trees.

g.
