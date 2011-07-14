Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab1GNN2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:28:53 -0400
Received: from ftcsun4.faraday-tech.com ([60.248.181.187]:39900 "EHLO
	ftcsun4.faraday.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1GNN2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:28:51 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case
Date: Thu, 14 Jul 2011 21:28:46 +0800
Message-ID: <B3F95056718EDE47B73D925D2FF34506782BDB@EX1.faraday.com.tw>
In-Reply-To: <20110714103624.GG7149@linutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case
thread-index: AcxCEeWS6TZEgqu7SxWMoVMdi9v2OgAF58JA
References: <cover.1310289795.git.joe@perches.com> 
    <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com> 
    <20110714080830.GA7149@linutronix.de> 
    <B3F95056718EDE47B73D925D2FF34506782BC2@EX1.faraday.com.tw> 
    <20110714103624.GG7149@linutronix.de>
From: =?big5?B?V2VuZHkgWXVhbi1Ic2luIENoZW4os6+kuMTJKQ==?= 
	<yhchen@faraday-tech.com>
To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
Cc: "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Joe Perches" <joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Sebastian Andrzej Siewior [mailto:bigeasy@linutronix.de] 
Sent: Thursday, July 14, 2011 6:36 PM
To: Wendy Yuan-Hsin Chen(³¯¤¸ÄÉ)
Cc: Felipe Balbi; Greg Kroah-Hartman; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Joe Perches
Subject: Re: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case

* Wendy Yuan-Hsin Chen(??????) | 2011-07-14 16:36:39 [+0800]:

>>>diff --git a/drivers/usb/gadget/fusb300_udc.c
>>>b/drivers/usb/gadget/fusb300_udc.c
>>>index 06353e7..453bc0f 100644
>>>--- a/drivers/usb/gadget/fusb300_udc.c
>>>+++ b/drivers/usb/gadget/fusb300_udc.c
>>>@@ -688,10 +688,13 @@ static void fusb300_cmp_dbg_fifo(struct fusb300_ep *ep,
>>> 	switch (length % 4) {
>>> 	case 1:
>>> 		golden_value = *tmp;
>>>+		break;
>>> 	case 2:
>>> 		golden_value = *tmp | *(tmp + 1) << 8;
>>>+		break;
>>> 	case 3:
>>> 		golden_value = *tmp | *(tmp + 1) << 8 | *(tmp + 2) << 16;
>>>+		break;
>>> 	default:
>>> 		break;
>>> 
>
>>That is in an #if 0 block. Maybe we should remove the #if 0? Yuan-Hsin?
>
>It's ok to remove the #if 0. But the warning will occur while compling.

By removing the #if 0 block I meant to remove the unused functions
fusb300_cmp_dbg_fifo() and fusb300_dbg_fifo(). There should be no warning then.
Are you okey with this? Are those function required?

These funtions are used for debugging. I think it's ok to remove them. Thanks.

Yuan-Hsin

********************* Confidentiality Notice ************************
This electronic message and any attachments may contain
confidential and legally privileged information or
information which is otherwise protected from disclosure.
If you are not the intended recipient,please do not disclose
the contents, either in whole or in part, to anyone,and
immediately delete the message and any attachments from
your computer system and destroy all hard copies.
Thank you for your cooperation.
***********************************************************************

