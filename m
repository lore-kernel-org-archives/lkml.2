Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab2ACLyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 06:54:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40033 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2ACLyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 06:54:08 -0500
MIME-Version: 1.0
In-Reply-To: <4F02C50E.9030904@metafoo.de>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
	<4F02C50E.9030904@metafoo.de>
Date: Tue, 3 Jan 2012 17:24:07 +0530
Message-ID: <CAJuYYwR8hnxJSfaXo4=RWCZ1HQZ1PHci+jY3K5b9ktWXryN0vA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/4] lcd: platform-lcd: Add lcd panel and device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On 3 January 2012 14:36, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 01/02/2012 06:54 AM, Thomas Abraham wrote:
>> The platform-lcd driver depends on platform-specific callbacks to setup the
>> lcd panel. These callbacks are supplied using driver's platform data. But
>> for adding device tree support for platform-lcd driver, providing such
>> callbacks is not possible (without using auxdata).
>>
>> Since the callbacks are usually lcd panel specific, it is possible to include
>> the lcd panel specific setup and control functionality in the platform-lcd
>> driver itself, thereby eliminating the need for supplying platform specific
>> callbacks to the driver. The platform-lcd driver can include support for
>> multiple lcd panels.
>>
>> This patchset removes the need for platform data for platform-lcd driver and
>> adds support which can be used to implement lcd panel specific functionality
>> in the driver. As an example, the support for Hydis hv070wsa lcd panel is added
>> to the platform-lcd driver which is then used on the Exynos4 based Origen board.
>> This currently breaks build for other users of platform-lcd driver. Those can be
>> fixed if this approach is acceptable.
>
> The whole approach looks rather backwards to me. The exact purpose of the
> platform_lcd driver is to redirect the lcd driver callbacks to board code.
> So by removing this support you not only break all the existing driver but
> also create a driver which does nothing. Then you add another layer of
> abstraction to implement custom drivers in this driver. A better approach in
> my opinion is to simply implement these drivers as first level LCD drivers.
> So leave the platform-lcd driver as it is and just add a gpio (or maybe
> regulator) lcd driver instead.

The existing platform-lcd driver mostly depends on the platform
callbacks for lcd panel power controls. Looking at the current users
of platform-lcd driver, a majority of the users of platform-lcd driver
use a gpio to enable/disable the display/power. The gpio is controlled
by the platform callbacks which the platform-lcd driver calls.

Hence, it is possible to extend the platform-lcd driver to include the
functionality of managing the gpio for lcd control. The platform code
is only expected to provide a gpio number to the platform-lcd driver.
This allows consolidation of the all the different platform callbacks
that use a gpio for simple enable/disable of the lcd display.

But there are other users of platform-lcd that do lot more than just
control a single gpio. For such cases, it is possible to reuse the
existing infrastructure of platform-lcd driver and extend it to handle
such lcd panel specific functionality.

The main advantages that I see here is the consolidation of platform
specific callbacks into the driver which inturn allows adding device
tree support without depending on platform data which have pointers to
platform specific functions. In the next version of this patchset, it
will be ensured that no platform breaks due to this change.

Would such a approach be useful and acceptable? Thanks for your
feedback and comments.

Regards,
Thomas.

>
> - Lars
