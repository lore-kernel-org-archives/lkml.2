Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab2ACI1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:27:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60922 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2ACI1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:27:23 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-d8-4f02bbe17e52
From: Chanho Park <chanho61.park@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: swarren@nvidia.com, Baohua.Song@csr.com, linux-kernel@vger.kernel.org
References: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
 <CACRpkdaS7843scS5jwVajMzrUy3c7bSUHMW7n+=fkk6XTEKfDA@mail.gmail.com>
In-reply-to: <CACRpkdaS7843scS5jwVajMzrUy3c7bSUHMW7n+=fkk6XTEKfDA@mail.gmail.com>
Subject: RE: [PATCH 0/2] add support for partial pin space
Date: Tue, 03 Jan 2012 17:27:13 +0900
Message-id: <007f01ccc9f1$7ebc4230$7c34c690$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczJ7VZYdLm6rQR7QlWtDX+JRSLeEgAAWBgw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus W.,
Original code always enumerate from 0 to maxpin because you wrote
as an offset equals to a pin number. It's inefficient because we always
define and enumerate whole pins in the system even though we do not use
the pin.
The pin space was already stored as array in the pin controller descriptor.
And we also have a number of pins.

Please see below example,

static const struct pinctrl_pin_desc pads[] = {
	PINCTRL_PIN(100, "PIN100"),
	PINCTRL_PIN(9999, "PIN9999"),
};
In this extreme system, the system has two pins.
We do not support non-zero based pin starting number.
And we always do silly loop until 0 to 9999. :)

This patch enables to enumerate the pin space by using the offset of array.
Thus, we don't need maxpin to enumerate the pin space because it is
sufficient
to use npins.

Best Regards,
Chanho Park


> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Tuesday, January 03, 2012 4:57 PM
> To: Chanho Park
> Cc: swarren@nvidia.com; Baohua.Song@csr.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 0/2] add support for partial pin space
> 
> On Tue, Jan 3, 2012 at 8:47 AM, Chanho Park <chanho61.park@samsung.com>
> wrote:
> 
> > A pin space of current pinctrl driver always start with zero-based
> pin
> > number. And pins are enumerated from 0 to a max pin number. If there
> are
> > two pins (one is 0, another is 1000), we always enumerate from 0 to
> 1000
> > for just only two pins. This patch enables to start non-zero based
> pin
> > number and to enumerate actually owned pins.
> >
> > For example, there is a system which has huge(500 or 1000) pins. If
> muxing
> > or controlling pins are small, we just define such small pins instead
> of
> > whole pins.
> 
> Seems like you're fixing my code to do what was originally intended :-)
> 
> The maxpin member was something I introduced for sparse ranges
> which would auto-register "dummy pins" for those not included in the
> enumeration.
> 
> That doesn't quite work, so was left behind.
> 
> I'll try applying the patches and see what happens.
> 
> Yours,
> Linus Walleij

