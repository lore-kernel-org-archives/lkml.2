Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031581Ab2CFXNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:13:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54964 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031544Ab2CFXNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:13:14 -0500
Date: Tue, 6 Mar 2012 23:13:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, grant.likely@secretlab.ca
Subject: Re: [PATCH] ARM: versatile: automatically pick a board in Kconfig
Message-ID: <20120306231306.GE15201@n2100.arm.linux.org.uk>
References: <1331074162-18147-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331074162-18147-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 03:49:22PM -0700, mathieu.poirier@linaro.org wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The versatile platform supports building any combination of the
> three board types (AB, PB, DT), but at least one of them has
> to be enabled. This adds the necessary Kconfig statement to
> enforce that at least one of the three is selected.

This approach to 'fixing' the Kconfig doesn't scale particularly well
when we've got lots of platforms to deal with.

I much prefer using KALLCONFIG= to seed allno/allyes/allmod/rand configs.
If you want to target a particular SoC you have to do that anyway.  And
you have to use that to ensure that you get a sane config state so that
Kconfig doesn't try and ask for the PHYS_OFFSET value - it will decide
to make that empty and then refuse to reprocess the Kconfig when you
try to build the kernel.

So I don't think there's any point to adding stuff like this.
