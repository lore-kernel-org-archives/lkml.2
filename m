Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1ACTg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:36:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51372
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284Ab1ACTgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:36:54 -0500
Date: Mon, 03 Jan 2011 11:37:26 -0800 (PST)
Message-Id: <20110103.113726.246525147.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: ben@decadent.org.uk, netdev@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: eepro testing positive EBUSY return by
 request_irq()?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D209127.5080505@gmail.com>
References: <4D1DECFC.8020701@gmail.com>
	<1293809262.2870.45.camel@localhost>
	<4D209127.5080505@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: roel kluin <roel.kluin@gmail.com>
Date: Sun, 02 Jan 2011 15:52:23 +0100

> +		for (i = 0; i < ARRAY_SIZE(irqlist); i++) {
> +			retval = request_irq (irqlist[i], NULL, 0, "bogus", NULL);
> +			if (retval != -EBUSY)
> +				continue;
> +			if (retval < 0)
> +				goto out;
> +			dev->irq = irqlist[i];
> +			break;

This series of tests don't make much sense.

If we get to the "retval < 0" check, retval must be -EBUSY.  So at
best it's superfluous, at worst it's confusing.
