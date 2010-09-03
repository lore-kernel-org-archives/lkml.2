Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab0ICOyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:54:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60566 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756121Ab0ICOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:54:22 -0400
Date: Fri, 3 Sep 2010 15:54:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Fix machine constraints apply for min_uV !=
 max_uV
Message-ID: <20100903145420.GB7614@rakim.wolfsonmicro.main>
References: <1283521429-32499-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283521429-32499-1-git-send-email-jhnikula@gmail.com>
X-Cookie: Life is not for everyone.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 04:43:49PM +0300, Jarkko Nikula wrote:
> Constraints are not applied until both min_uV and max_uV are the same. This
> looks like a typo in the test.
> 
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>

This is deliberate behaviour, apply_uV can only be used with a fixed
voltage at startup in order to avoid issues with handover from the
bootloader if we suddenly drop the supply voltage on a device which has
not yet been claimed by a driver.  The expectation is that if the
voltage can vary then something that understands the hardware state
needs to be involved in maintaining the voltage.
