Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0EaLat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:30:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34743
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab0EaLar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:30:47 -0400
Date: Mon, 31 May 2010 04:30:56 -0700 (PDT)
Message-Id: <20100531.043056.258120791.davem@davemloft.net>
To: fthain@telegraphics.com.au
Cc: geert@linux-m68k.org, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] mac8390: change an error return code and some cleanup,
 take 4
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1005312011210.469@nippy.intranet>
References: <alpine.LNX.2.00.1005311905520.469@nippy.intranet>
	<AANLkTilkooBglbk33yDHmk8c_ZdlamOW8FVvuvjQaNsF@mail.gmail.com>
	<alpine.LNX.2.00.1005312011210.469@nippy.intranet>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fthain@telegraphics.com.au
Date: Mon, 31 May 2010 21:07:09 +1000 (EST)

> Apparently David now wants me to submit this again --
> 
> if (ei_debug)
> 	pr_debug(...)
> 
> David, if that code is acceptable, please let me know.

The only thing I care about is at the moment that you don't do
something that ends up dropping the pr_fmt prefix.

The pr_fmt define at the beginning of the driver is for nothing
if we end up adding exceptions that end up eliding it for no
good reason.  And that's what your patch was doing.

