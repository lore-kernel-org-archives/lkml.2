Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1EOXes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:34:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53468 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab1EOXeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:34:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/6] PM: Support for generic I/O power domains (v3)
Date: Mon, 16 May 2011 01:17:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104290154.12966.rjw@sisk.pl> <201105082320.57185.rjw@sisk.pl>
In-Reply-To: <201105082320.57185.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105160117.46927.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second update of the patchset adding support for generic I/O power
domains. Patches [1-5/6] have been posted and discussed already, although in
a slightly different form.  The last patch is new.  The short description of
all the patches and changes since the previous update follow.

The patches are on top of the branch at:
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git power-domains
which is going to be pushed for 2.6.40.  I'd like to push patch [1/6] for
2.6.40 too, since it's only slightly related to the rest of the patchset that
depends on it.  Patches [2-5/6] are regarded as 2.6.41 material.  Patch [6/6]
is an RFC and it may become 2.6.41 material depending on what you think.

The entire patchset has been tested with an ARM shmobile Mackerel board.

[1/6] - Introduction of generic prepare and complete callbacks for subsystems.
        This patch hasn't changed since it was posted last time.

[2/6] - Support for generic I/O power domains (runtime PM part).
        There are a few changes relative to the previous version.  First,
        I added CONFIG_PM_GENERIC_DOMAINS to be selected by platforms
        wanting to use the new code (this allows, for example, x86 to avoid
        compiling it unnecessarily).  Second, the loop over devices in
        __pm_genpd_poweroff() doesn't increment "not_suspended" for devices
        without drivers, so that they don't prevent the domain from being
        powered down.  Finally, the kerneldoc comment for pm_genpd_init()
        has been fixed.

[3/6] - Support for generic I/O power domains (system sleep part).
        pm_genpd_prepare() has been modified to execute pm_runtime_resume()
        for the device is the domain's power_is_off flag is clear (the
        device needs to be "active" from the runtime PM viewpoint, so that
        we can save its registers before suspending the whole system).
        Accordingly, pm_genpd_suspend() and pm_genpd_freeze() don't call
        pm_runtime_resume() any more (they don't need to do that).

[4/6] - Implementation of generic I/O power domains support for SH7372.

[5/6] - Introduction of SH7372's A4MP power domain.

[6/6] - [RFC] Support of multiple power domain states.
        This shows how I think we can handle multiple power domain states
        on top of the previous patches.

Comments welcome.

Thanks,
Rafael
