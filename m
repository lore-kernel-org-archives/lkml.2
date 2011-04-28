Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab1D1KGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:06:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40840 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754256Ab1D1KGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:06:21 -0400
Date: Thu, 28 Apr 2011 11:06:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: kalle.jokiniemi@nokia.com
Cc: lrg@slimlogic.co.uk, mchehab@infradead.org, svarbatov@mm-sol.com,
        saaguirre@ti.com, grosikopulos@mm-sol.com, vimarsh.zutshi@nokia.com,
        Sakari.Ailus@nokia.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC] Regulator state after regulator_get
Message-ID: <20110428100629.GA14494@opensource.wolfsonmicro.com>
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 09:01:03AM +0000, kalle.jokiniemi@nokia.com wrote:

> If the device driver using the regulator does not enable and disable the
> regulator after regulator_get, the regulator is left in the state that it was
> after bootloader. In case of N900 this is a problem as the regulator is left
> on to leak current. Of course there is the option to let regulator FW disable
> all unused regulators, but this will break the N900 functionality, as the
> regulator handling is not in place for many drivers. 

You should use regulator_full_constraints() if your board has a fully
described set of regulators.  This will cause the framework to power
down any regulators which aren't in use after init has completed.  If
you have some regulators with no consumers or missing consumers you need
to mark them as always_on in their constraints.

> So reset the regulator on first regulator_get call to make
> sure that any regulator that has users is not left active
> needlessly.

This would cause lots of breakage, it would mean that all regulators
that aren't always_on would get bounced off at least once during startup
- that's not going to be great for things like the backlight.
