Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1GRMyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:54:41 -0400
Received: from ftcsun4.faraday-tech.com ([60.248.181.187]:56336 "EHLO
	ftcsun4.faraday.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab1GRMyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:54:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case
Date: Mon, 18 Jul 2011 20:54:32 +0800
Message-ID: <B3F95056718EDE47B73D925D2FF34506782CB0@EX1.faraday.com.tw>
In-Reply-To: <20110718083640.GB2837@legolas.emea.dhcp.ti.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/5] fusb300_udc: Add missing breaks in switch/case
thread-index: AcxFJdb0C9Emr+OcRuCNiADL/09UZwAIufng
References: <cover.1310289795.git.joe@perches.com> 
    <08f6dd600dbf588e87734b3a6b33d897cd253fe3.1310289795.git.joe@perches.com> 
    <20110714080830.GA7149@linutronix.de> 
    <B3F95056718EDE47B73D925D2FF34506782BC2@EX1.faraday.com.tw> 
    <20110714103624.GG7149@linutronix.de> 
    <B3F95056718EDE47B73D925D2FF34506782BDB@EX1.faraday.com.tw> 
    <20110718083640.GB2837@legolas.emea.dhcp.ti.com>
From: =?big5?B?V2VuZHkgWXVhbi1Ic2luIENoZW4os6+kuMTJKQ==?= 
	<yhchen@faraday-tech.com>
To: <balbi@ti.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Joe Perches" <joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >>>diff --git a/drivers/usb/gadget/fusb300_udc.c
> >>>b/drivers/usb/gadget/fusb300_udc.c
> >>>index 06353e7..453bc0f 100644
> >>>--- a/drivers/usb/gadget/fusb300_udc.c
> >>>+++ b/drivers/usb/gadget/fusb300_udc.c
> >>>@@ -688,10 +688,13 @@ static void fusb300_cmp_dbg_fifo(struct fusb300_ep *ep,
> >>> 	switch (length % 4) {
> >>> 	case 1:
> >>> 		golden_value = *tmp;
> >>>+		break;
> >>> 	case 2:
> >>> 		golden_value = *tmp | *(tmp + 1) << 8;
> >>>+		break;
> >>> 	case 3:
> >>> 		golden_value = *tmp | *(tmp + 1) << 8 | *(tmp + 2) << 16;
> >>>+		break;
> >>> 	default:
> >>> 		break;
> >>> 
> >
> >>That is in an #if 0 block. Maybe we should remove the #if 0? Yuan-Hsin?
> >
> >It's ok to remove the #if 0. But the warning will occur while compling.
> 
> By removing the #if 0 block I meant to remove the unused functions
> fusb300_cmp_dbg_fifo() and fusb300_dbg_fifo(). There should be no warning then.
> Are you okey with this? Are those function required?
> 
> These funtions are used for debugging. I think it's ok to remove them. Thanks.

maybe make a debugfs interface instead ?

These functions were used to debug unstable hw fifo while developing fusb300.  It's much more stable now.
So these functions can be removed. Thanks for your advice.

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

