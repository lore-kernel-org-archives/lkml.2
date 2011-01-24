Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1AXOls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 09:41:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44519 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab1AXOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:41:47 -0500
Date: Mon, 24 Jan 2011 14:41:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 20/28] ARM: tegra: cpufreq: Disable cpufreq during
	suspend
Message-ID: <20110124144142.GA16813@sirena.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-21-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295834493-5019-21-git-send-email-ccross@android.com>
X-Cookie: Pause for storage relocation.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 06:01:25PM -0800, Colin Cross wrote:
> Adds a SUSPEND_PREPARE notification hook to drop the frequency to
> the lowest possible during suspend.  This prevents the cpufreq driver
> from attempting regulator calls after suspend has started - the
> regulator api can call into drivers that have already been suspended.

Hrm, what's the situation where that happens and why does it cause
problems?  The regulator API doesn't care if suspend is going on, and
nor do any of the current drivers for regulators.  There is an issue
with keeping things like I2C alive until the bitter end of suspend so
you've got a control bus to the regulators but that's a generic issue
which crops up with other subsystems too so a regulator-specific
workaround seems dodgy.

The patch itself seems fine, it's just that it feels like there's
something else going on.
