Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1CNRBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:01:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53589 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1CNRBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:01:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Mon, 14 Mar 2011 18:01:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: matti.j.aaltonen@nokia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103141700.26457.arnd@arndb.de> <99B09243E1A5DA4898CDD8B7001114481082FAE168@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481082FAE168@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103141801.01333.arnd@arndb.de>
X-Provags-ID: V02:K0:RMAqGJ/qAGQ19Zd1xe1JbHpZxOuFo70Db0t6Fb7Ggod
 anPxvFOYZu4O8q/w39pw3g2nXkJIwt2Gb5cknuQcczFT9ENK75
 9yaBFEjf7AhztxL/Itzn4WE9ble/+HpgmB21uQilStWU0/icSB
 WeOpinsec3PnKVa5fsl3cPS4Ah8XUnfk+Z4yrm2NipRLbDwvS9
 1sFrWuSPJHiiPTIW+CxPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >> No, it's simply there as I have been faceing i2c write error while I 
> >> do two consecutive writes.
> >> The second fails now and then. That's seems to be a chip issue.
> >> I will try to investigate this issue.
> >
> >Ok. It sounds like a bug in the i2c driver, you should also 
> >take a look there. Maybe it has never had to deal with this 
> >much write data at once.
> 
> It's been confirmed now that this is how chip is supposed to work and the
> driver should not care about this scenario. Upper layers (onfc stack) handle this.
> Thus, will simply remove urange_sleep and that's it.

It sounds strange that this will be handled in user space, since
it won't have any idea if the hardware is available again.

I've tried to find the onfc stack that talks to this device but
couldn't see it. Do you have a URL for this?

	Arnd
