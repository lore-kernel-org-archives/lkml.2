Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1GFVBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:01:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33617 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1GFVBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:01:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/5 v1] PM / Domains: Generic PM domains improvements
Date: Wed, 6 Jul 2011 22:48:35 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107062248.35586.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For the last few days I've been working on modifications of the generic
PM domains code allowing .start_device()/.stop_device() and drivers'
.runtime_suspend()/.runtime_resume() callbacks to execute things like
pm_runtime_resume() for other devices in the same PM domain safely
without deadlocking (the original motivation was a console driver on
shmobile that pm_runtime_get_*()/pm_runtime_put_*() are called for from
the other devices' .runtime_suspend()/.runtime_resume() callbacks).

I think I solved that problem, but in the process I found a few places
where fixes and/on improvements were necessary.  The patches in this
series address those issues.  They are on top of the branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains

Patches [1-2/5] are regarded as 3.1 material, the others not necessarily,
but I'd like to push them for 3.1 too if there are no complaints.

Thanks,
Rafael

