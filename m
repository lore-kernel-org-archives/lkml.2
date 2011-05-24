Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1EXFIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:08:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61419 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1EXFIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:08:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6355"; a="93185795"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        "'Mike Frysinger'" <vapier@gentoo.org>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org> <1306132882-9668-5-git-send-email-tlinder@codeaurora.org> <20110523123135.GA10785@linutronix.de>
In-Reply-To: <20110523123135.GA10785@linutronix.de>
Subject: RE: [PATCH v12 4/8] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Tue, 24 May 2011 08:10:23 +0300
Message-ID: <00eb01cc19d0$e526a9b0$af73fd10$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwZRVssFknSazKrSUqUkXrTKIcAbgAiwKRg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

> >+	case USB_REQ_GET_STATUS:
> >+		if (!gadget_is_superspeed(gadget))
> >+			goto unknown;
> >+		if (ctrl->bRequestType != (USB_DIR_IN |
> USB_RECIP_INTERFACE))
> >+			goto unknown;
> >+		value = 2;	/* This is the length of the get_status
reply
> */
> >+		*((__le16 *)req->buf) = 0;
> 
> Mike please correct me if I'm wrong bug this looks like a case for
> put_unaligned_le16().
> Is someone actually using gadget support on blackfin? I'm asking
> because
> config_buf() (same file, upstream) is using req->buf to build the
> descriptors in place and one element is le16 which should be affected.
> 

Mike answered that you're right in your observation. I'm not familiar with
blackfin. Could you please elaborate on this? I understand that I need to
use put_unaligned_le16(), will do, but I would like to better understand why
and if there is a way to test this so that blackfin won't be broken.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




