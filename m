Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1IUCxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 22:53:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39434 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1IUCxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 22:53:47 -0400
Date: Tue, 20 Sep 2011 22:49:10 -0400 (EDT)
Message-Id: <20110920.224910.1996429830782124690.davem@davemloft.net>
To: robherring2@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org, dave.martin@linaro.org,
        linux@arm.linux.org.uk, rob.herring@calxeda.com
Subject: Re: [PATCH 0/3] GIC OF bindings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 20 Sep 2011 19:49:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robherring2@gmail.com>
Date: Tue, 20 Sep 2011 15:24:01 -0500

> Hopefully, this is the final or near final version of GIC binding support.
> 
> Changes from the previous version:
> - SPIs and PPIs are numbered starting at 0. Now the gic has it's own irq
>   domain translate function instead of the simple domain one.
> - interrupt cell format has changed based on Grant's proposal.
> - Dropped "ARM: gic: allow irq_start to be 0". Instead, the first 16 irqs
>   are skipped and the domain irq_base adjusted accordingly.
> - Added a fix to of_irq_find_parent when the parent == child.
> - Renamed intc_desc.parent to intc_desc.interrupt_parent.
> - Implemented Grant's algorithm for walking the list of interrupt
>   controllers. Added a return value to interrupt init functions, so they
>   don't get added to the parent list on a init failure.
> 
> The changes are significant enough that I did not include previous
> acked/reviewed/tested-by's.

Just out of curiosity where does this "interrupt-parent" property
come from?

On platforms I am familiar with, the parent path is walked to the root
and we stop at device nodes that have "interrupt-map" and
"interrupt-map-mask" properties.

The map and mask are applied to the "reg" property of the device in
question to see which map entry matches, if a match is found the map
entry contains the translated interrupt.

And this process continues over and over all the way to the root to get
the system interrupt that processor actually deals with.

The mechanism shown here seems overly simplistic and not able to handle
the cases handled by existing OF property schemes in use for several
years on real systems.
