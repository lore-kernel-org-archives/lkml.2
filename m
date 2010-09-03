Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0ICVsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:48:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53656
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932118Ab0ICVsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:48:16 -0400
Date: Fri, 03 Sep 2010 14:48:33 -0700 (PDT)
Message-Id: <20100903.144833.108785087.davem@davemloft.net>
To: akepner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] notify user-level IRQ balancer when kernel assigns
 IRQ affinity
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100903210554.GO2464@sgi.com>
References: <20100903210554.GO2464@sgi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arthur Kepner <akepner@sgi.com>
Date: Fri, 3 Sep 2010 14:05:54 -0700

> 
> We've run into situations where a CPU runs out of interrupt 
> vectors, because all the interrupts are getting the default 
> affinity (and the interrupt balancer hasn't yet run).
> 
> The following emits a netlink message whenever an interrupt 
> is given a default CPU affinity. A user-level IRQ balancer 
> can use those messages to decide if, and how to reassign 
> affinities. This should allow us to avoid running out of 
> vectors on any particular CPU (or at least make it far less 
> likely).
> 
> I know this needs work, but would like to get comments on 
> the idea before doing more coding and testing.
> 
> Signed-off-by: Arthur Kepner <akepner@sgi.com>

As I replied to you on netdev, this can't possibly work.

Interrupt allocation needs to work properly before userspace
even starts up.  So the allocation management must be inside
of the kernel entirely.

