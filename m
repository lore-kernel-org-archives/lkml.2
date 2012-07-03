Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2GCWcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:32:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55259 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998Ab2GCWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:32:33 -0400
Date: Tue, 3 Jul 2012 23:32:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: don't fail to apply_uV for fixed regulators
	without set_voltage
Message-ID: <20120703223226.GA11368@opensource.wolfsonmicro.com>
References: <1341353014-13005-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341353014-13005-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 04:03:34PM -0600, Stephen Warren wrote:

> When instantiating a regulator from device tree,
> of_get_regulation_constraints() sets apply_uV=true when min_uV==max_uV.
> If the regulator only supports that one voltage, it may not implement
> set_voltage or set_voltage_sel. If so, the call from
> machine_constraints_voltage() to _regulator_do_set_voltage() will fail,
> since the latter requires one of those ops to be implemented. Avoid this
> problem by avoiding the call to _regulator_do_set_voltage() if the
> regulator is already set of the specified voltage.

This just seems like someone's written a silly device tree - they're
asking the OS to set a voltage on something with a fixed voltage.  From
discussion on IRC it seems like this was a misunderstanding on your part
about what one is intended to put in the device tree, the idea is that
the DT should only specify things that are changed on the board - users
shouldn't need to cut'n'paste information that's fixed in the PMIC
silicon into each board DT.

Besides, there's clearly not anything specific to setting constraints
about this...
