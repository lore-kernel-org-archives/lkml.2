Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0JEVm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:42:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58948 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0JEVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:42:26 -0400
Date: Tue, 5 Oct 2010 22:42:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] misc: Driver for APDS990X ALS and proximity sensors
Message-ID: <20101005214220.GB19895@sirena.org.uk>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com> <1286271779-19819-4-git-send-email-samu.p.onkalo@nokia.com> <20101005122323.2d2870ee@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005122323.2d2870ee@lxorguk.ukuu.org.uk>
X-Cookie: Love is sentimental measles.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 12:23:23PM +0100, Alan Cox wrote:

> > +	chip->regs[0].supply = reg_vcc;
> > +	chip->regs[1].supply = reg_vled;

> Shouldn't these come from the provided platform data ? and again if there
> isn't a platform one supplied just skip the regulators. There are going

No, don't do this.  The device should just request the supplies that
correspond to the physical supplies for the device and let the regulator
API worry about actually providing regulators to match it.  If
regulators are getting passed in as platform data something has gone
wrong.

> to be cases of boxes with regulator API stuff in use but who don't have
> regulators for that device.

If there genuinely is no supply present on the pin then the device needs
to know that; if there is a supply present but it's not software managed
then the regulator API can cope with that.

Trying to handle this in individual device drivers just results in reams
of cut'n'paste code in device drivers, frequently requring the addition
of platform data to devices that would not otherwise require any.  We've
tried it, it's painful.  Having the machine specific data provided as a
generic regulator API service provides a great degree of simplification.
