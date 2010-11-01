Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0KAHPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 03:15:09 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:8254 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203Ab0KAHPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 03:15:07 -0400
Message-ID: <002701cb7994$81db1350$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Marc Kleine-Budde" <mkl@pengutronix.de>
Cc: "Wolfgang Grandegger" <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Christian Pellegrin" <chripell@fsfe.org>,
        "Barry Song" <21cnbao@gmail.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <andrew.chih.howe.khor@intel.com>,
        <qi.wang@intel.com>, <margie.foster@intel.com>,
        <yong.y.wang@intel.com>, "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        <kok.howg.ewe@intel.com>, <joel.clark@intel.com>
References: <4CCAA3D4.8070408@dsn.okisemi.com> <4CCAC4CD.7000503@pengutronix.de>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build warnings
Date: Mon, 1 Nov 2010 16:15:01 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 29, 2010 9:57 PM : Marc Kleine-Budde wrote:
>>>> SW must check busy flag of CAN register.
>>>> This is a Topcliff HW specification.
>>> Maybe the busy check could also be done *before* the Message RAM is
>>> accessed to avoid (or minimize) waiting.
>> Yes, *before* is right.
>> If there is *after* processing, this is a bug.
>> Can you see anyway ?
>Sorry I don't understand what you mean.

Sorry, my English had mistake. I show my comment below again.
 - If there is *after* processing, this is a bug.
 - Can you see the point anywhere ?

> You probably know the datasheet, but I don't, although I've printed
> chapter 13 from the Intel Controller Hub EG20T datasheet, but it's 50+
> pages. If the hardware needs the busy waiting in the hot tx path a
> pointer to the respective section in the manual is a good idea. Just
> something like:

Though "Oliver Hartkopp" found the place of Datasheet EG20T and notified with the mailing-list,
Have you read the following ?
http://edc.intel.com/Platforms/Atom-E6xx/#hardware

>>> You have to change the definition of the regs struct a bit:
>>>>  u32 if1_mcont;
>>>>  u32 if1_data[4];
>>>>  u32 reserve2;
>> Uh, I can't find this. Where is this ?
>Here's a patch to illustrate what I meant:
I understand.


Thanks, Tomoya(OKI SEMICONDUCTOR CO., LTD.)
