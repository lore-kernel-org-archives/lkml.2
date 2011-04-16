Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab1DPXox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 19:44:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1DPXor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 19:44:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/9] PM: Rework shmobile and OMAP runtime PM using power domains
Date: Sun, 17 Apr 2011 01:35:18 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl>
In-Reply-To: <201104130205.26988.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104170135.19388.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches is my attempt to consolidate the shmobile and
OMAP runtime PM code using power domains so that it is not necessary to
replace the platform bus type's runtime PM callbacks any more.

Some of the patches have already been posted, some are new and some are
from Kevin. :-)

[1/9] - Make power domain callbacks take precedence over subsystem ones
        (this one has been discussed already).

[2/9] - Export the platform bus type's default PM callbacks so that they
        can be used in power domain objects.

[3/9] - Use a default power domain for runtime PM on shmobile (both ARM
        and SH flavors) instead of replacing the platform bus type's
        runtime PM callbacks (using __weak).

[4/9] - Use generic runtime PM callbacks directly in the platform bus type.

[5/9] - Move OMAP2 runtime PM implementation to using a power domain object
        (patch from Kevin rebased on top of [1-4/9]).

[6/9] - Add subsystem data field to struct dev_pm_info.

[7/9] - Introduce generic clock manipulation routines for runtime PM and
        convert ARM shmobile to using them.

[8/9] - Move OMAP1 runtime PM to the new core infrastructure.

[9/9] - Remove platform_bus_set_pm_ops() (patch from Kevin).

Comments welcome.

Thanks,
Rafael

