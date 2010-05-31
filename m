Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0EaNCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 09:02:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56655
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530Ab0EaNCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 09:02:16 -0400
Date: Mon, 31 May 2010 06:02:25 -0700 (PDT)
Message-Id: <20100531.060225.68146363.davem@davemloft.net>
To: fthain@telegraphics.com.au
Cc: geert@linux-m68k.org, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] mac8390: change an error return code and some cleanup,
 take 4
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.OSX.2.00.1005312244520.1490@localhost>
References: <alpine.LNX.2.00.1005312011210.469@nippy.intranet>
	<20100531.043056.258120791.davem@davemloft.net>
	<alpine.OSX.2.00.1005312244520.1490@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Mon, 31 May 2010 22:55:23 +1000 (EST)

> if (ei_debug)
> 	pr_debug(...)
> 
> OR
> 
> if (ei_debug)
> 	pr_info(...)

Well for the printk in question, it's telling the user that
a certain feature can't be enabled.

And if the driver has an explicit way to control this message,
using ei_debug, it's kind of redundant to slap another layer on
top by using the debug printk facility.

Changing this to a debug log level printk is only going to make
getting the debug message shown harder for the user.  So leaving it at
pr_info() is just as correct in my eyes.

Finally, your patch has so many problems getting applied because
you're doing multiple things in one patch.

And in fact I've asked you not to do this on several occiaions.

Fix the error return codes in one patch, and nothing more.
Then in another you can masterbate with printk log levels.
