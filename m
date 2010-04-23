Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0DWCrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:47:48 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:36379 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab0DWCrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:47:46 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: core: workque: workqueue recursion when unplugging usb WCDMA modem on 2.6.32 kernel
Date: Thu, 22 Apr 2010 19:46:18 -0700
Message-ID: <ED2979D1CA1B3E4BB166ED9990088522765FF0@SJOAMSEXB01.AMERICAS.ROOT.PRI>
In-Reply-To: <s2qd6200be21004221628nd2a93a29x7eab5841bba1c673@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: core: workque: workqueue recursion when unplugging usb WCDMA modem on 2.6.32 kernel
Thread-Index: Acric3vBvS4UsErLShmZae81Y0C/ggAFfu4g
References: <ED2979D1CA1B3E4BB166ED9990088522765C8C@SJOAMSEXB01.AMERICAS.ROOT.PRI> <20100421182747.GB7876@kroah.com> <ED2979D1CA1B3E4BB166ED9990088522765E30@SJOAMSEXB01.AMERICAS.ROOT.PRI> <s2qd6200be21004221628nd2a93a29x7eab5841bba1c673@mail.gmail.com>
From: "YuPing Luo" <YuPing.Luo@csr.com>
To: =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
X-OriginalArrivalTime: 23 Apr 2010 02:47:01.0313 (UTC) FILETIME=[3FDD0310:01CAE28F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Arve Hjønnevåg [mailto:arve@android.com] Sent: Friday, April 23, 2010 7:28 AM
> I don't think this is related to your console. I could easily
> reproduce your problem by killing rild (which uses both the binder and
> ttys). You may also what to find out why your rild is exiting.

I make the rild service stopped while vold daemon detect usb-modem unplugged.

>>  The recursion can be avoided if introducing one dedicated work queue
>> thread for binder 
> I just pushed a fix that does exactly that.
Good news, and just confused while the workqueue introduced in binder, why the tty_release() triggered by its work handler, the normal case looks like following:

(tty_release+0x1c/0x28)
[   68.068397] [<c021f16c>] (tty_release+0x0/0x28) from [<c01318f8>] (__fput+0xe0/0x210)
[   68.076177]  r5:00000008 r4:c69009c0
......
[   68.102362]  r7:00000006 r6:c69009c0 r5:c78a60c0 r4:c281e000
[   68.108026] [<c012f748>] (sys_close+0x0/0x110) from [<c0089f40>] (ret_fast_syscall+0x0/0x2c)
[   68.116453]  r7:00000006 r6:0002ac60 r5:00000010 r4:0002ef08
[   68.122068] ---[ end trace 6c2209be9c1c296c ]---
[   68.234009] option_release

Thanks
Yuping


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
