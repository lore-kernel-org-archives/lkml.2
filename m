Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0KMHpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:45:24 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33734 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab0KMHpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:45:23 -0500
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: Vitaly Wool <vitalywool@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 13 Nov 2010 13:12:34 +0530
Subject: RE: shared transport: only for TI chips?
Thread-Topic: shared transport: only for TI chips?
Thread-Index: AcuCppN+uAWuQiuIQIascPpFiByFfQAX8KyV
Message-ID: <19F8576C6E063C45BE387C64729E739404A9F4CF11@dbde02.ent.ti.com>
References: <AANLkTikLJyr6PREZX-OwOBwMK8uTC2YEu-KHHy0MYFJJ@mail.gmail.com>
In-Reply-To: <AANLkTikLJyr6PREZX-OwOBwMK8uTC2YEu-KHHy0MYFJJ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

certainly Vitaly.
I would welcome any ideas which can make it more generic, provided there is no drastic change in the way we do stuff currently (as in say firmware download from kernel space, LL handling etc..).

I did see similar code for on such MFD device from ST-ericsson for a similar BT, FM GPS based device and wanted to somehow make work TI-ST work for it, unfortunately didn't hear encouraging words from developers from that driver.

So, yes, I welcome ideas and let's see how best we can implement them... shoot them away...

----------------------
Thanks & Regards,
Pavan Savoy | x0099669
________________________________________
From: Vitaly Wool [vitalywool@gmail.com]
Sent: Saturday, November 13, 2010 1:47 AM
To: Savoy, Pavan
Cc: LKML
Subject: shared transport: only for TI chips?

Hi Pavan,

I've been looking closely at the shared transport implementation to
figure out how applicable it is for similar solutions from other
vendors. My current impression is, this the applicability is very
poor.
For instance, you define the firmware name by querying the chip in a
specific manner. Also, your implementation presumes the chip
implements LL protocol for Bluetooth power saving which might not at
all be the case for other vendors' chips. That's kind of okay as long
as you don't care about power saving; but if you have to support some
other power saving protocol, you're screwed -- there's no such
opportunity in the current ST core.

So the question is, are you at all interested in making the core
generic? I'm ready to come up with some ideas on that if the answer is
positive :)

And if not, we need to consider bringing in something more generic as
there already are several vendors that use Bluetooth for command
encapsulation on similar multi-functional chips.

Thanks,
   Vitaly