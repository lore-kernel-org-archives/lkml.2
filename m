Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0K3Dhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:37:48 -0500
Received: from kroah.org ([198.145.64.141]:56745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0K3Dho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:37:44 -0500
Date: Mon, 29 Nov 2010 19:30:07 -0800
From: Greg KH <greg@kroah.com>
To: Andres Salomon <dilinger@queued.net>
Cc: akpm@linux-foundation.org, dsd@laptop.org, stable@kernel.org,
        cjb@laptop.org, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: [stable] [PATCH] cs5535-gpio: apply CS5536 errata workaround
 for GPIOs
Message-ID: <20101130033007.GB13386@kroah.com>
References: <20101129171930.2297083d@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129171930.2297083d@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 05:19:30PM -0800, Andres Salomon wrote:
> 
> The AMD Geode CS5536 Companion Device Silicon Revision B1 Specification Update
> mentions the follow as issue #36:
> 
> "Atomic write transactions to the atomic GPIO High Bank Feature Bit registers
> should only affect the bits selected [...]"
> "after Suspend, an atomic write transaction [...] will clear all non-selected
> bits of the accessed register."
> 
> In other words, writing to the high bank for a single GPIO bit will clear
> every other GPIO bit (but only sometimes after a suspend).  The workaround
> described is obvious and simple; do a read-modify-write.  This patch does
> that, and documents why we're doing it.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Please read Documentation/stable_kernel_rules.txt for how to get patches
into the stable kernel releases (hint, this wasn't the proper way...)

thanks,

greg k-h
