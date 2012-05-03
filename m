Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab2ECTNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:13:09 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52922 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2ECTNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:13:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120503184756.GA21032@core.coreip.homeip.net>
References: <20120503171058.GA20605@core.coreip.homeip.net>
 <Pine.LNX.4.44L0.1205031317070.1232-100000@iolanthe.rowland.org>
 <CAPXgP13XJeuTvhP1RoipFn2fOTb+XN+CxHSJc-hPy+YLEHH1_g@mail.gmail.com> <20120503184756.GA21032@core.coreip.homeip.net>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 3 May 2012 21:12:43 +0200
Message-ID: <CAPXgP11ktmMcLvwYy9PvyZ_J9bmmAzdmqzKCVE6Q0dbKHyG9eg@mail.gmail.com>
Subject: Re: proper struct device selection for dev_printk()
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 8:47 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, May 03, 2012 at 07:50:52PM +0200, Kay Sievers wrote:

>> I guess it all depends who is the consumer of the messages, and I
>> would say if userspace is the intended consumer, always use the device
>> that provides the access/interface to userspace. It's easy to walk up
>> the tree and find out about the other things.
>
> This would be:
>
> 1. Impossible in most cases
> 2. If it was possible it woudl have to be layer violation.

Yeah, if it would be easy, Greg would not have written the mail. :)

> Taking psmouse as an example you have no idea which interface to use to
> report errors - mouse2, event6 or js1 - these are what visible from
> userspace and all of them could report to the same input device.

True, if the error does not propagate up to the class device, it does
not sound right to do that. But it's still the case that userspace or
any automated message consumer cannot make much sense out of the
message then. It's still targeted at a human.

> We
> however know exactly what serio port we had trouble with.

Sure, if the error occurs in that context, it should be logged with
exactly that context. If it propagates up to the higher devices they
should log themselves.

The point I tried to make was, that we should not in general walk up
to the next bus device for logging, and that the parent devices are
not more useful in general. I wanted to express that a rule like: "In
general, drivers should emit messages for the devices they bind to."
is not the right thing to do, if we *can* establish a context to the
device that is used in userspace.

But sure, if the error can not be propagated to the child devices, we
should not fake anything here either, but the stuff should stay where
it happened.

> Now consider error happending on i8042 level. Do we descend into
> serio layer and reportan error there? Why? Serio layer is perfectly
> fine, and besides why would we confuse user that psmouse driver had an
> issue whereas it was i8042 that needs to be looked at?

As said, it all depends on the intended consumer. Messages about
i8042 devices are not interesting at all for userspace or for
automatic log analysis.

> Also, I do not think that vague "userspace" is consumer for these
> messages; this is really something a human needs to look at and analyze.

Right, they are mainly useful for a human being only. So the attached
metadata does not really matter that much.

Kay
