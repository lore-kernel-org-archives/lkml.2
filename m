Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0CVA4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:56:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45860
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347Ab0CVA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:56:29 -0400
Date: Sun, 21 Mar 2010 17:56:51 -0700 (PDT)
Message-Id: <20100321.175651.91333124.davem@davemloft.net>
To: stefani@seibold.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] fix PHY polling system blocking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1269208490.5748.44.camel@wall-e.seibold.net>
References: <1267894258.18869.2.camel@wall-e>
	<20100312144248.ade8b700.akpm@linux-foundation.org>
	<1269208490.5748.44.camel@wall-e.seibold.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>
Date: Sun, 21 Mar 2010 22:54:50 +0100

> The phylib has also a drawback, because it polls the PHY despite if it
> has interrupt support for it or not. I can't see a reason for this
> behavior.

Careful, in my experience many PHYs that do have interrupt
support have buggy implementations to the point where the
interrupt support cannot be used at all.

Typically the problem is that events aren't reported reliably.

So I just wanted you to keep in mind that a chip having
interrupt support doesn't automatically mean it can be used.
