Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1HWRL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:11:57 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:35366 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab1HWRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:11:52 -0400
From: Kevin Hilman <khilman@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 3.1-rc3] gpio/omap: fix build error with certain OMAP1 configs
Organization: Texas Instruments, Inc.
References: <201108231342.25101.jkrzyszt@tis.icnet.pl>
Date: Tue, 23 Aug 2011 10:11:47 -0700
In-Reply-To: <201108231342.25101.jkrzyszt@tis.icnet.pl> (Janusz Krzysztofik's
	message of "Tue, 23 Aug 2011 13:42:24 +0200")
Message-ID: <87sjoshx2k.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> writes:

> With commit f64ad1a0e21a, "gpio/omap: cleanup _set_gpio_wakeup(), remove 
> ifdefs", access to build time conditionally omitted 'suspend_wakeup' 
> member of the 'gpio_bank' structure has been placed unconditionally in 
> function _set_gpio_wakeup(), which is always built. This resulted in the 
> driver compilation broken for certain OMAP1, i.e., non-OMAP16xx, 
> configurations.
>
> Really required or not in previously excluded cases, define this 
> structure member unconditionally as a fix.
>
> Tested with a custom OMAP1510 only configuration.
>
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Verified that this fixes a build problem when building for OMAP1
(730/850 only)

Acked-by: Kevin Hilman <khilman@ti.com>

Grant, can you queue this as a fix for 3.1-rc?

Thanks,

Kevin
