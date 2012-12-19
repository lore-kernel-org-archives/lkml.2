Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2LSPlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:41:19 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38415 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2LSPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:41:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121219083430.GB3400@breakpoint.cc>
References: <fdcd8d23149d.149dfdcd8d23@huawei.com> <fdcdb3e12b55.2b55fdcdb3e1@huawei.com>
 <20121218141013.GB4939@breakpoint.cc> <910F9D9E13B84F4C8FA771DC9BDE99F326FCB006@szxeml546-mbs.china.huawei.com>
 <20121219083430.GB3400@breakpoint.cc>
From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Date: Wed, 19 Dec 2012 07:40:52 -0800
Message-ID: <CAA6KcBDPv4AuZg0yrjomtD4W2PFkd_W52ksWsU=b_D5M9CYUng@mail.gmail.com>
Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        Huqiao <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 12:34 AM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> On Wed, Dec 19, 2012 at 03:13:32AM +0000, Fangxiaozhi (Franko) wrote:
>> > And shouldn't you read something from the us->recv_bulk_pipe after
>> > that?
>>       Well, because our device will re-connect to switch the ports if it receives the command.
>>       So it is not necessary to read the response of the command.
>
> Hmm. I guess this for Matthew / Greg to decide, I don't insist on anything.
> Maybe a comment would be nice because now it looks, atleast to me, that
> something is missing.

I think an unusual situation like that deserves a comment that
explains that the device is about to disconnect / reconnect, so
reading status is not necessary.

I am also concerned about the error of using &bcbw instead of bcbw.  I
doubt this code would have worked with that typo in place.  How was
this patch tested?

Also, the dongles_pid function is really just a different
implementation of the unusual_devs.h table.  I think that it is much
easier for people to add new entries to the table, rather than edit
your code, when new dongles are released.  BUT, your code includes
many more PIDs than the table did.  Again, how was this tested for the
new PIDs covered?  At a minimum, some comment in dongles_pid is
required to highlight this area of code for possible future expansion
as new devices are released.

Matt

-- 
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
