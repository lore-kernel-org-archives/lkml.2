Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab1DONWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:22:05 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:55132 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1DONWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:22:00 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Mark Lord <kernel@teksavvy.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Justin Maggard <jmaggard10@gmail.com>
Date: Fri, 15 Apr 2011 14:21:56 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: Acv7BBINsfN9++uST4qZDCrJX4jqcQASVxxw
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C772DA5DD@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA5BCF3.5080205@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772DA491@gretna.indigovision.com>
 <4DA79134.1010508@teksavvy.com>
In-Reply-To: <4DA79134.1010508@teksavvy.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3FDMNNJ027041

> > I also tried out my tracing in writelfl (without any other changes) and I was
> > able to lock up a port without any apparent unusual changes to the register
> > containing the irq masks.  Are there other routes to disabling the irqs?
>
> Mmm.. presumably you are NOT using MSI interrupts, right?

Hi Mark,

That is correct:

sata_mv 0000:00:04.0: Gen-II 32 slots 4 ports SCSI mode IRQ via INTx

I am building with CONFIG_ARCH_SUPPORTS_MSI=y, but also with CONFIG_PCI_MSI
not set.

With all this discussion of SATA link speed, I ought to say that we limit our
SATA links to 1.5Gbps with the following kernel parameter:

libata.force=1.5g

I had noticed occasional messages similar to the following earlier in the week:

ata4.00: limiting speed to UDMA/100:PIO4

I was surprised to see them, and thought they might be related to the hotplug
issues, but I was able to reproduce the lockups without these messages being
generated.  In some cases (but not all) both sata_down_spd_limit and
ata_down_xfermask_limit are called when backing off the link speed.

Mark, I was intrigued by your comment from the following message:

http://www.spinics.net/lists/linux-ide/msg36922.html
> If it's like their non-AHCI controllers (sata_mv), then the chipset/phy
> could be very particular about the sequence/timing used when changing speeds.

Is it possible that the driver is doing some of the work to change the link
speed (even though it has nowhere to go) and clobbering the link entirely?
I shall take another closer look at the source code and tracing around hotplug
w.r.t. link speed.


Cheers,

Bruce.


Bruce Stenning,
IndigoVision,
b <dot> stenning <at> indigovision <dot> com


Latest News at: http://www.indigovision.com/index.php/en/news.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
