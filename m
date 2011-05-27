Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1E0OjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:39:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41085 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1E0OjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:39:15 -0400
Date: Fri, 27 May 2011 15:39:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Colin Cross <ccross@google.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, linux-sh@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add a generic struct clk
Message-ID: <20110527143909.GA24011@sirena.org.uk>
References: <1305876469.325655.313573683829.0.gpush@pororo> <BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com> <20110524062620.GA22096@pengutronix.de> <BANLkTimEoCaKwJtpbQTDSEDydNkZ1BkKog@mail.gmail.com> <20110524080936.GI20715@pengutronix.de> <BANLkTinVnFasvOmu0MWRDzv21P3vM8eM6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinVnFasvOmu0MWRDzv21P3vM8eM6g@mail.gmail.com>
X-Cookie: Stay on the trail.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:41:20PM -0700, Colin Cross wrote:

> figure out how to call clk_set_rate on the single clock that is
> exposed to the device, but not propagate it past the device clock if
> the device clock doesn't have a divider (propagating it up to an
> active pll feeding other devices results in disaster, at least on

This is usually a function of how shared the thing being changed is
rather than the specific implementation, though PLLs and FLLs are
obviously problematic due to the lock time (if they don't have
glitchless handover logic).

> Tegra).  This combination doesn't seem to be common in your MX code,
> but _every_ Tegra device clock has these three parts.

That's Tegra.  Other devices will have other structures.
