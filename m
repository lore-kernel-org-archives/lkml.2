Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab1CCBnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:43:51 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:52583 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1CCBnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:43:50 -0500
Date: Wed, 02 Mar 2011 20:43:32 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT] idle patches for 2.6.38-rc7
Message-id: <alpine.LFD.2.02.1103022041370.12344@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-release

This will update the files shown below.

thanks!

Len Brown
Intel Open Source Technology Center

 arch/x86/include/asm/msr-index.h |    5 +++++
 drivers/idle/intel_idle.c        |   24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

through these commits:

Len Brown (2):
      intel_idle: disable NHM/WSM HW C-state auto-demotion
      intel_idle: disable Atom/Lincroft HW C-state auto-demotion

with this log:

commit bfb53ccf1c734b1907df7189eef4c08489827951
Author: Len Brown <len.brown@intel.com>
Date:   Wed Feb 16 01:32:48 2011 -0500

    intel_idle: disable Atom/Lincroft HW C-state auto-demotion
    
    Just as we had to disable auto-demotion for NHM/WSM,
    we need to do the same for Atom (Lincroft version).
    
    In particular, auto-demotion will prevent Lincroft
    from entering the S0i3 idle power saving state.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=25252
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 14796fca2bd22acc73dd0887248d003b0f441d08
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jan 18 20:48:27 2011 -0500

    intel_idle: disable NHM/WSM HW C-state auto-demotion
    
    Hardware C-state auto-demotion is a mechanism where the HW overrides
    the OS C-state request, instead demoting to a shallower state,
    which is less expensive, but saves less power.
    
    Modern Linux should generally get exactly the states it requests.
    In particular, when a CPU is taken off-line, it must not be demoted, else
    it can prevent the entire package from reaching deep C-states.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=25252
    
    Signed-off-by: Len Brown <len.brown@intel.com>
