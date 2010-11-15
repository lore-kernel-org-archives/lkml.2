Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab0KOHjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:39:36 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:43797 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576Ab0KOHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:39:34 -0500
Message-ID: <000e01cb8498$3ec2cb80$66f8800a@maildom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: <andrew.chih.howe.khor@intel.com>,
        "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>, <margie.foster@intel.com>,
        <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
        <socketcan-core@lists.berlios.de>, <yong.y.wang@intel.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, "David S. Miller" <davem@davemloft.net>,
        "Christian Pellegrin" <chripell@fsfe.org>, <qi.wang@intel.com>
References: <4CCAA3D4.8070408@dsn.okisemi.com>	<4CCAC4CD.7000503@pengutronix.de> <4CCAF517.2000409@pengutronix.de>	<4CCB213A.2020206@grandegger.com> <004a01cb825a$3a8bd060$66f8800a@maildom.okisemi.com> <4CDD28E6.9060006@grandegger.com>
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build warnings
Date: Mon, 15 Nov 2010 16:39:28 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 12, 2010 8:45 PM, Wolfgang Grandegger wrote:

> >> This is an enumeration:
> >>
> >> enum {
> >> PCH_STUF_ERR = 1,
> >> PCH_FORM_ERR,
> >> PCH_ACK_ERR,
> >> PCH_BIT1_ERR;
> >> PCH_BIT0_ERR,
> >> PCH_CRC_ERR,
> >> PCH_LEC_ALL;
> >> }
> > 
> > No, 
> > LEC is for bit assignment.
> > Thus, "enum" can't be used.
> 
> Why? For me it's a classical enum because the value matters, and *not*
> the individual bit. Do you agree?

Sorry, at last, I understand your saying.
I agree.



> >> Also, could you please add the TEC and REC:
> >>
> >> cf->data[6] = ioread32(&priv->regs->errc) & CAN_TEC;
> >> cf->data[7] = (ioread32(&priv->regs->errc) & CAN_REC) >> 8;
> > 
> > I will add.
> 
> BTW: it could be done with one I/O call:
> 
>   errc = ioread32(&priv->regs->errc);
>   cf->data[6] = errc & CAN_TEC;
>   cf->data[7] = (errc & CAN_REC) >> 8;
> 
> > But I couldn't find 
> 
> Don't understand? It's also implemented for the SJA1000 driver:

Sorry, the above my line is fogotten to delete.
I can uderstand your saying.

---
Thanks,

Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.
