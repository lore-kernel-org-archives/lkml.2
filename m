Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0DKUSs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 16:18:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35632
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab0DKUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 16:18:46 -0400
Date: Sun, 11 Apr 2010 13:18:50 -0700 (PDT)
Message-Id: <20100411.131850.226764423.davem@davemloft.net>
To: cristiklein@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: add setsockopt to disable slow start after idle
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BC218B6.8050703@gmail.com>
References: <4BC06A5F.6070804@gmail.com>
	<20100410.154709.201110995.davem@davemloft.net>
	<4BC218B6.8050703@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cristian KLEIN <cristiklein@gmail.com>
Date: Sun, 11 Apr 2010 20:45:10 +0200

> Without this patch, an application which needs this behaviour
> (i.e. not to slow start after idle) is forced to implement its own
> UDP-based protocol with all the congestion control, retransmission
> etc. Undue congestion might still occur.

Ask your system administrator to set the existing sysctl, because it
is a physical network attribute whether this behavior is safe or not.

And if it is safe, it is safe for all applications, there is no reason
for one application to ask for it and others to not.  If it's legal,
it helps all applications without exception.

Your attempts to tie this to NAGLE is complete nonsense.

NAGLE changes acking behavior, whereas this feature controls in what
way we trust congestion control information we've probed for in the
past.
