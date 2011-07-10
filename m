Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1GJJLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 05:11:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42115 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab1GJJJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 05:09:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/6 v2] PM / Domains: Generic PM domains improvements
Date: Sun, 10 Jul 2011 10:59:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
References: <201107062248.35586.rjw@sisk.pl>
In-Reply-To: <201107062248.35586.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107101059.30322.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The majority of patches have been updated since the last submission and there's
one new patch, so it's the time for a refresh. :-)

All patches in this series have been posted already (the last one without
a changelog, though).

On Wednesday, July 06, 2011, Rafael J. Wysocki wrote:
> 
> For the last few days I've been working on modifications of the generic
> PM domains code allowing .start_device()/.stop_device() and drivers'
> .runtime_suspend()/.runtime_resume() callbacks to execute things like
> pm_runtime_resume() for other devices in the same PM domain safely
> without deadlocking (the original motivation was a console driver on
> shmobile that pm_runtime_get_*()/pm_runtime_put_*() are called for from
> the other devices' .runtime_suspend()/.runtime_resume() callbacks).
> 
> I think I solved that problem, but in the process I found a few places
> where fixes and/on improvements were necessary.  The patches in this
> series address those issues.

[1/6] - Set device state to "active" during system resume.

[2/6] - Make failing pm_genpd_prepare() clean up properly.

[3/6] - Rework generic PM domains locking so that device callbacks are not
        executed under the genpd lock.

[4/6] - Allow device callbacks executed by the generic PM domains code to
        run runtime PM helpers safely (ie. without deadlocking).

[5/6] - Avoid restoring the states of all devices on failing domain power off.

[6/6] - Imorove the handling of system wakeup devices during system suspend.

The series is on top of the branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains
 
All patches in this series are regarded as 3.1 material.

Thanks,
Rafael

