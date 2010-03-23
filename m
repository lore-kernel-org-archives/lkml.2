Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab0CWDvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:51:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35566
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358Ab0CWDvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:51:21 -0400
Date: Mon, 22 Mar 2010 20:51:44 -0700 (PDT)
Message-Id: <20100322.205144.256859987.davem@davemloft.net>
To: justinmattock@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: forcedeth: cat /sys/class/net/eth0/carrier = Invalid argument
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA7AA92.5040400@gmail.com>
References: <4BA7AA92.5040400@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. mattock" <justinmattock@gmail.com>
Date: Mon, 22 Mar 2010 10:36:18 -0700

> I've pushed my kernel from the latest HEAD to 2.6.31
> and am still seeing:
> cat /sys/class/net/eth0/carrier
> cat: carrier: Invalid argument
> 
> with my other machine using sky2
> the same results is:
> cat /sys/class/net/eth0/carrier
> 0
> 
> is there anything on this? before I start
> a bisect.(looking through bugzilla, I couldn't
> see anything related).

A device is not able to indicate carrier accurately when
the device is not currently running.

So you will get an -EINVAL until the device is brought up.

The reason is that most drivers don't even probe the link
or negotiate link speed and flow control until the device
is brought up.  Many don't even power up the PHY when the
device is down, in order to save power.

So the behavior you observe is completely expected.
