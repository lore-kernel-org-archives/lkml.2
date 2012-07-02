Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2GBMhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 08:37:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45378 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2GBMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 08:37:46 -0400
Date: Mon, 2 Jul 2012 13:37:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ShuoX Liu <shuox.liu@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Build failures in -next due to move of disable
Message-ID: <20120702123740.GA11168@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Murphy was an optimist.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's -next is failing to build for me because commit 9f419c (PM /
Domains: Add preliminary support for cpuidle) and commit b32e30
(cpuidle: move field disable from per-driver to per-cpu) disagree about
where the disable field should be:

  CC      drivers/base/power/domain.o
drivers/base/power/domain.c: In function '__pm_genpd_poweron':
drivers/base/power/domain.c:194: error: 'struct cpuidle_state' has no member named 'disable'
drivers/base/power/domain.c: In function 'pm_genpd_poweroff':
drivers/base/power/domain.c:490: error: 'struct cpuidle_state' has no member named 'disable'
drivers/base/power/domain.c: In function 'genpd_attach_cpuidle':
drivers/base/power/domain.c:1671: error: 'struct cpuidle_state' has no member named 'disable'
drivers/base/power/domain.c: In function 'genpd_detach_cpuidle':
drivers/base/power/domain.c:1706: error: 'struct cpuidle_state' has no member named 'disable'
