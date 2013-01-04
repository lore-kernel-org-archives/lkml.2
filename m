Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3ADHbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:31:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:22694 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3ADHbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:31:06 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>
Subject: RE: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Topic: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
Thread-Index: AQHN3S0ND+lW0hLXaU2nh0KFaWLeCZgfb78g///XHgCAAHcgAIAZGcYA
Date: Fri, 4 Jan 2013 07:30:53 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F326FE89DF@szxeml546-mbs.china.huawei.com>
References: <fdcd8d23149d.149dfdcd8d23@huawei.com>
 <fdcdb3e12b55.2b55fdcdb3e1@huawei.com> <20121218141013.GB4939@breakpoint.cc>
 <910F9D9E13B84F4C8FA771DC9BDE99F326FCB006@szxeml546-mbs.china.huawei.com>
 <20121219083430.GB3400@breakpoint.cc>
 <CAA6KcBDPv4AuZg0yrjomtD4W2PFkd_W52ksWsU=b_D5M9CYUng@mail.gmail.com>
In-Reply-To: <CAA6KcBDPv4AuZg0yrjomtD4W2PFkd_W52ksWsU=b_D5M9CYUng@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.182]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r047VG4K013570

Dear Matthew:


> -----Original Message-----
> From: Matthew Dharm [mailto:mdharm-usb@one-eyed-alien.net]
> Sent: Wednesday, December 19, 2012 11:41 PM
> To: Sebastian Andrzej Siewior
> Cc: Fangxiaozhi (Franko); linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; Xueguiying (Zihan); Linlei (Lei Lin);
> greg@kroah.com; Yili (Neil); Wangyuhua (Roger, Credit); Huqiao; balbi@ti.com
> Subject: Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
> devices and support new switch command
> 
> On Wed, Dec 19, 2012 at 12:34 AM, Sebastian Andrzej Siewior
> <sebastian@breakpoint.cc> wrote:
> > On Wed, Dec 19, 2012 at 03:13:32AM +0000, Fangxiaozhi (Franko) wrote:
> >> > And shouldn't you read something from the us->recv_bulk_pipe after
> >> > that?
> >>       Well, because our device will re-connect to switch the ports if it
> receives the command.
> >>       So it is not necessary to read the response of the command.
> >
> > Hmm. I guess this for Matthew / Greg to decide, I don't insist on anything.
> > Maybe a comment would be nice because now it looks, atleast to me,
> > that something is missing.
> 
> I think an unusual situation like that deserves a comment that explains that the
> device is about to disconnect / reconnect, so reading status is not necessary.
	You mean that we have to add some comment in the source code, 
to explain why we don't read the response. Right?
	
> 
> I am also concerned about the error of using &bcbw instead of bcbw.  I doubt
> this code would have worked with that typo in place.  How was this patch
> tested?
> 
> Also, the dongles_pid function is really just a different implementation of the
> unusual_devs.h table.  I think that it is much easier for people to add new
> entries to the table, rather than edit your code, when new dongles are released.
> BUT, your code includes many more PIDs than the table did.  Again, how was
> this tested for the new PIDs covered?  
	In the dongles_pid function, we have check all the product IDs for our dongles, which is assigned for all of our Mobile Broadband products in our company. So the product ID of our new dongle in future, will also be included in this list.
	In our lab, we can configure our dongle firmware to support all of these product ID. We have test them(cover all the product ID), and this function works fine.

>At a minimum, some comment in
> dongles_pid is required to highlight this area of code for possible future
> expansion as new devices are released.
	As far as I know, the product ID list in dongles_pid function includes all. We will not add any other product ID for our dongle. So we need not update the product ID list in dongles_pid function in future.
	However, I also will add the comment to highlight the area of code, as your advice did.
> 
> Matt
> 
> --
> Matthew Dharm
> Maintainer, USB Mass Storage driver for Linux

Best Regards,
Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
