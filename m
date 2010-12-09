Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0LICjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 21:39:18 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54176
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756293Ab0LICjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 21:39:16 -0500
Date: Wed, 08 Dec 2010 18:39:42 -0800 (PST)
Message-Id: <20101208.183942.226776000.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan@hartkopp.net
Subject: Re: linux-next: build failure after merge of the net tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101209132836.6f6acfb8.sfr@canb.auug.org.au>
References: <20101209132836.6f6acfb8.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 9 Dec 2010 13:28:36 +1100

> After merging the net tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/net/can/slcan.c: In function 'slcan_open':
> drivers/net/can/slcan.c:568: error: dereferencing pointer to incomplete type

That's amazing that with all the header files this driver includes,
powerpc somehow doesn't get the task_struct definition :-)

I'll add the obvious linux/sched.h include to fix this, thanks!
