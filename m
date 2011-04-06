Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1DFOL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:11:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58615 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755986Ab1DFOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:11:27 -0400
Date: Wed, 6 Apr 2011 23:11:33 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
Message-ID: <20110406141131.GC2810@opensource.wolfsonmicro.com>
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:21:19AM +0200, Antonio Ospite wrote:

> +	tristate "Generic rfkill regulator driver"
> +	depends on RFKILL || !RFKILL

That looks *odd*.  Otherwise this looks fine from a regulator API point
of view.  You use an exclusive get() so you could get away without
remembering the enable state as nothing else could hold the device open
but there's no harm in doing so and it's defensive against silly
constraints that force the regulator on.
