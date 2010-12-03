Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab0LCA7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:59:06 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14631 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab0LCA7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:59:04 -0500
Message-ID: <00c001cb9285$46adc4d0$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "David Miller" <davem@davemloft.net>
Cc: <wg@grandegger.com>, <w.sang@pengutronix.de>, <chripell@fsfe.org>,
        <21cnbao@gmail.com>, <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <joel.clark@intel.com>, <kok.howg.ewe@intel.com>,
        <margie.foster@intel.com>
References: <4CF47B2C.4010507@dsn.okisemi.com> <20101202.131236.28815617.davem@davemloft.net>
Subject: Re: [PATCH net-next-2.6 v6 04/20] can: EG20T PCH: Add Tx Flow Control
Date: Fri, 3 Dec 2010 09:58:59 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010 6:12 AM, David Miller wrote :

> 
> When implementing functionality like this it is better to use other
> existing well tested network drivers as a guide rather then trying
> to be unique and clever, as you are doing here.

Sure. I will do so.

> 
> Second of all, checking the state of the device to determine if a
> stop queue should be performed has two problems:
> 
> 1) The test uses a magic constant mask, which is undocumented.

Do you above "magic constant" mean "0xfc00" ?
If so, this constant is replaced to MACRO in 08/20 patch. 

> 
> 2) It causes the race you have on the wake queue side
> 
> Use pure software state to guide your actions, and let the hardware
> interrupt trigger the wake queue.
> 
> Also, you don't implement this as a true ring buffer, you only
> consider to stop the queue when you hit the last TX object entry.  But
> all the previous slots could be available.

We can't use ring buffer.
Because ring buffer causes issue of tx packet out-of-order.

I show EG20T CAN HW spec below
According to priority, EG20T CAN HW sends packet from message object.
The priority is Message object number.
Lower number is high-priority, Higher is low priority

Thus, I think we can't use ring buffer.

Still, do you think I can use ring buffer ?
------
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
