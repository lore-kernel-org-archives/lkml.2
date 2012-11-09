Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab2KICgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:36:31 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49781 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab2KICga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:36:30 -0500
MIME-Version: 1.0
In-Reply-To: <20121108163835.GA8877@core.coreip.homeip.net>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
	<20121108163835.GA8877@core.coreip.homeip.net>
Date: Fri, 9 Nov 2012 08:06:29 +0530
Message-ID: <CAKohpo=PdNoBzpZoHWcHSqh_az2OOGGGegNzCXPxjUDVOHostw@mail.gmail.com>
Subject: Re: [PATCH 1/3] input: spear-keyboard: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2012 22:08, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Thu, Nov 08, 2012 at 07:10:47PM +0530, Viresh Kumar wrote:
> It also breaks the error unwinding/removal of the driver as it frees
> input device while IRQ handler is still active.

I have heard of this argument before, probably from you. :)
Just need clarification again. How will we get an interrupt when the controller
is stopped, unless we have a shared irq.

> I will push the patch which implements devm_input_allocate_device() to
> my 'next' branch in a few, please use it because it will make sure input
> device will stick around long enough.

Will surely use that.

>> +     kbd->io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
>
> There is devm_request_and_ioremap() which you can use here.

Should have been done in V1 only.

--
viresh
