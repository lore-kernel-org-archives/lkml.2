Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1DLKbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:31:05 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:46721 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab1DLKbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:31:03 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Mark Lord <kernel@teksavvy.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Date: Tue, 12 Apr 2011 11:30:56 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: Acv2T/QddD3kTEOkT2S0YbDAMLj0GAB/rKbw
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
In-Reply-To: <4D9FACC9.7020200@teksavvy.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3CAVECa004085

> > The 2.6.38.2 kernel still exhibits the same lockups that we see with the
> > 2.6.26 kernel.
>
> Okay.  Just to help narrow it down a bit, how does 2.6.32 behave ?
>
> Thanks.

Hi Mark,

I have reproduced the issue with the 2.6.32 kernel.

In case it is of use, the silicon is rev 09 (i.e. C0 stepping) and I am using
gcc 4.4.2 to build the kernel and modules.

I am currently inserting tracing into 2.6.38.2 to try to work out what is going
on.  From mv_write_main_irq_mask I can see that the IRQ for each port is still
enabled, even when ports stop responding.  I see interrupts generated when I
hotplug or unplug disks on ports that are not locked up, but no interrupt is
generated at all for the ports that are locked (this is from tracing in
asm_do_IRQ in arch/arm/kernel/irq.c)

One thing I noticed was that there is no spinlock around the
mv_save_cached_regs/mv_edma_cfg in mv_hardreset (unlike mv_port_start and
mv_port_stop); why is this?


Kind Regards,

Bruce Stenning,
IndigoVision,
b <dot> stenning <at> indigovision <dot> com


Latest News at: http://www.indigovision.com/index.php/en/news.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
