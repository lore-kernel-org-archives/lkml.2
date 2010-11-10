Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0KJQhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:37:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57375 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756824Ab0KJQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:37:34 -0500
Date: Wed, 10 Nov 2010 16:37:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: Re: [PATCH] regulator: enable supply regulator only when use count
 is zero
Message-ID: <20101110163732.GB6052@rakim.wolfsonmicro.main>
References: <1289383582-10183-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289383582-10183-1-git-send-email-bengt.g.jonsson@stericsson.com>
X-Cookie: Nihilism should commence with oneself.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:06:22AM +0100, Bengt Jonsson wrote:
> Supply regulators are disabled only when the last
> reference count is removed on the child regulator
> (the use count goes from 1 to 0). This patch changes
> the behaviour of enable so the supply regulator is
> enabled only when the use count of the child
> regulator goes from 0 to 1.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +	if (rdev->use_count == 0) {
> +		/* do we need to enable the supply regulator first */
> +		if (rdev->supply) {

This'd be a bit neater (and less invasive) as a single if statement with
&&.
