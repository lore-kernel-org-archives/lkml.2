Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1CWVVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:21:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40826 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753118Ab1CWVVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:21:13 -0400
Date: Wed, 23 Mar 2011 21:21:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: leds-regulator.c, fix handling already enabled
 regulators
Message-ID: <20110323212110.GA26862@opensource.wolfsonmicro.com>
References: <1300914002-17760-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300914002-17760-1-git-send-email-ospite@studenti.unina.it>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:00:02PM +0100, Antonio Ospite wrote:

> The leds-regulator driver was ignoring the initial status of the
> regulator; this resulted in rdev->use_count incremented up to 2 after
> calling regulator_led_set_value() in the .probe method when a regulator
> was already enabled at insmod time, and this made impossible to ever
> disable the regulator.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> NOTE: initially I thought about CC-ing stable@kernel.org as well on 
> this, as it is an actual fix, but then I checked that there are 
> currently no users of the driver in mainline linux and I dropped it, is 
> that how it should be?

Even if there's no users in mainline people could well be shipping out
of tree boards using it and could benefit from the code.  OTOH it's not
the most urgent thing ever.
