Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0LQNxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:53:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab0LQNxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:53:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 2.6.37
Date: Fri, 17 Dec 2010 14:52:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012171452.35295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

They include:

* Restoration of the old hibernate swap signature (I wanted to change it to
  avoid some potential problems, but it turned out that user space used the
  old signature and obviously didn't understand the new one).

* Fix for an ancient bug in the hibernate user interface from Takashi
  (the bug has been there forever, but we didn't have any code where it really
  mattered until very recently).

* Fix for a bug in pm_runtime_suspended() that prevents some devices from being
  suspended and resumed when they should, so it is potentially deadly.


 Documentation/power/runtime_pm.txt |    4 ++--
 include/linux/pm_runtime.h         |    3 ++-
 kernel/power/swap.c                |    2 +-
 kernel/power/user.c                |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

---------------

Rafael J. Wysocki (2):
      PM / Hibernate: Restore old swap signature to avoid user space breakage
      PM / Runtime: Fix pm_runtime_suspended()

Takashi Iwai (1):
      PM / Hibernate: Fix PM_POST_* notification with user-space suspend

