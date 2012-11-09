Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab2KIRF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:05:27 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52263 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab2KIRFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:05:22 -0500
MIME-Version: 1.0
In-Reply-To: <20121109053311.GA12105@core.coreip.homeip.net>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
	<20121108163835.GA8877@core.coreip.homeip.net>
	<CAKohpo=PdNoBzpZoHWcHSqh_az2OOGGGegNzCXPxjUDVOHostw@mail.gmail.com>
	<20121109053311.GA12105@core.coreip.homeip.net>
Date: Fri, 9 Nov 2012 22:35:22 +0530
Message-ID: <CAKohponYyB18B92tTxb8_e1dzJhaAL=tqnCJfh_DpoUHavdGVw@mail.gmail.com>
Subject: Re: [PATCH 1/3] input: spear-keyboard: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2012 11:03, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Fri, Nov 09, 2012 at 08:06:29AM +0530, Viresh Kumar wrote:
>> On 8 November 2012 22:08, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>> > On Thu, Nov 08, 2012 at 07:10:47PM +0530, Viresh Kumar wrote:
>> > It also breaks the error unwinding/removal of the driver as it frees
>> > input device while IRQ handler is still active.
>>
>> I have heard of this argument before, probably from you. :)
>> Just need clarification again. How will we get an interrupt when the controller
>> is stopped, unless we have a shared irq.
>
> My bad, I missed that spear-keyboard driver implements open() and
> close() methods and shuts off the device properly. Still, thanks for
> switching everything to devm_*, I think it is much cleaner this way as
> opposed to mixing managed and unmanaged resources.

Another fixup:

commit ebdec75f51050cf4a5ac41d3a1e880e14bf96a95
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Nov 9 22:28:48 2012 +0530

    fixup! input: spear-keyboard: Use devm_*() routines
---
 drivers/input/keyboard/spear-keyboard.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/keyboard/spear-keyboard.c
b/drivers/input/keyboard/spear-keyboard.c
index 25e0a3b..65f5950 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -292,7 +292,6 @@ static int __devexit spear_kbd_remove(struct
platform_device *pdev)
 {
        struct spear_kbd *kbd = platform_get_drvdata(pdev);

-       input_unregister_device(kbd->input);
        clk_unprepare(kbd->clk);

        device_init_wakeup(&pdev->dev, 0);
