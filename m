Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0JESoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:44:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57141
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab0JESop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:44:45 -0400
Date: Tue, 05 Oct 2010 11:45:06 -0700 (PDT)
Message-Id: <20101005.114506.184852374.davem@davemloft.net>
To: masa-korg@dsn.okisemi.com
Cc: mkl@pengutronix.de, sameo@linux.intel.com, chripell@fsfe.org,
        meego-dev@meego.com, morinaga526@dsn.okisemi.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, socketcan-core@lists.berlios.de,
        yong.y.wang@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, margie.foster@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, wg@grandegger.com
Subject: Re: [MeeGo-Dev][PATCH v3] Topcliff: Update PCH_CAN driver to 2.6.35
From: David Miller <davem@davemloft.net>
In-Reply-To: <002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>
References: <000401cb6477$25a0eba0$66f8800a@maildom.okisemi.com>
	<4CAB0732.3010400@pengutronix.de>
	<002e01cb6486$2ed72cc0$66f8800a@maildom.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Date: Tue, 5 Oct 2010 21:09:30 +0900

> On Tuesday, October 05, 2010 8:08 PM, Marc Kleine-Budde wrote:
>> If FIFO is working you might also think about NAPI.
> 
> I think NAPI isn't necessary for our CAN driver.
> NAPI is for high-speed networking.
> CAN is NOT high-speed.
> 
> In fact, some accepted CAN drivers don't have NAPI.

NAPI is not just for performance concerns.

It greatly simplifies the locking since all packet processing paths
run only in software interrupt context, never in hardware interrupt
context.

We encourage all new drivers that can use NAPI to do so, just because
recent driver submissions do not do this doesn't mean we should
continue such a mistake ;-)
