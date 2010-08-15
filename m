Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab0HOFTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:19:08 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:55691 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0HOFTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:19:07 -0400
Date: Sun, 15 Aug 2010 01:19:01 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull request] idle patches for Linux-2.6.36.merge
Message-id: <alpine.LFD.2.00.1008150117460.2294@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-pm@lists.linux-foundation.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.34/idle-release-2.6.34.diff.gz

 drivers/idle/Kconfig      |    3 +--
 drivers/idle/intel_idle.c |   45 ++-------------------------------------------
 2 files changed, 3 insertions(+), 45 deletions(-)

through these commits:

Arjan van de Ven (1):
      intel_idle: recognize Lincroft Atom Processor

Len Brown (4):
      intel_idle: delete power_policy modparam, and choose substate functions
      intel_idle: add support for Westmere-EX
      intel_idle: disable module support
      intel_idle: no longer EXPERIMENTAL

with this log:

commit 4725fd3ce970c27a1678fb0809bfc7c2f4ac3e4f
Author: Arjan van de Ven <arjan@linux.intel.com>
Date:   Wed Jul 21 23:42:25 2010 -0400

    intel_idle: recognize Lincroft Atom Processor
    
    Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5a5e28daea69652505ac07eb5fbda4d7f0534926
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 14:44:08 2010 -0400

    intel_idle: no longer EXPERIMENTAL
    
    This is a fully supported driver.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6ce9cd8669fa1195fdc21643370e34523c7ac988
Author: Len Brown <len.brown@intel.com>
Date:   Sat Aug 14 14:40:36 2010 -0400

    intel_idle: disable module support
    
    Right now the module capability is cauing more trouble
    than it is worth.  At least one distro built intel_idle as a module
    where it lost the init race with ACPI, making it useless.
    
    Make intel_idle bool so that if you select it, you will use it.
    
    We can restore module capability after cpuidle is enhanced
    to handle run-time changing of idle drivers.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ec67a2ba360d4874b1158e6e87fe1e859b0c9117
Author: Len Brown <len.brown@intel.com>
Date:   Mon Jul 26 23:40:19 2010 -0400

    intel_idle: add support for Westmere-EX
    
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 0394c6676e3fa48587fbe4821390d3264672c530
Author: Len Brown <len.brown@intel.com>
Date:   Fri Jul 23 16:04:46 2010 -0400

    intel_idle: delete power_policy modparam, and choose substate functions
    
    The idea behind power policy was that it would start off as a modparam,
    and then hook into the new "global" in-kernel power vs energy tunable.
    But that tunable isn't happening, so delete the hook here.
    
    With the policy hook gone, the sub-state choice functions
    do not do anything useful, so delete them from the critical path.
    
    To handle sub-states in the future, we will advertise them
    with dedicated cpuidle_state entries.  That is necessary
    because some of the sub-states will have substantially different
    properties than their peer sub-states.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
