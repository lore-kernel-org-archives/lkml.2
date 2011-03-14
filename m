Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1CNPDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:03:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47947 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391Ab1CNPDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:03:13 -0400
Date: Mon, 14 Mar 2011 15:03:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Igor Grinberg <grinberg@compulab.co.il>
Subject: Re: [PATCH v3] Regulator: add suspend-finish API for regulator
 core.
Message-ID: <20110314150330.GE2626@opensource.wolfsonmicro.com>
References: <1299806039-12698-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299806039-12698-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:13:59AM +0900, MyungJoo Ham wrote:
> The regulator core had suspend-prepare that turns off the regulators
> when entering a system-wide suspend. However, it did not have
> suspend-finish that pairs with suspend-prepare and the regulator core
> has assumed that the regulator devices and their drivers support
> autonomous recover at resume.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

We should be doing this automatically as part of the core but since
we've not done that for suspend yet it seems reasonable to apply as-is
then fix both the teardown and powerup paths together.  Since the code
won't be called unless someone explicitly does so there's very little
risk here.
