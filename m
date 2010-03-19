Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0CSPNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:13:35 -0400
Received: from kroah.org ([198.145.64.141]:51540 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab0CSPNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:13:31 -0400
Date: Fri, 19 Mar 2010 08:13:11 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.34-git
Message-ID: <20100319151311.GA8541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a number of bugfixes for the driver core for your 2.6.34-git
tree.

This series should resolve all of the sysfs lockdep warnings that have
been reported numerous times.  It also includes a number of
documentation updates and other small fixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 Documentation/kobject.txt           |   60 +++++++++++++++++++++++-----------
 drivers/base/class.c                |    2 +
 drivers/base/core.c                 |    6 +++
 drivers/base/cpu.c                  |   16 +++++-----
 drivers/base/firmware_class.c       |    2 +
 drivers/base/node.c                 |    7 +++-
 drivers/base/platform.c             |   33 +++++++++++++++----
 drivers/char/ipmi/ipmi_msghandler.c |   10 ++++++
 drivers/infiniband/core/sysfs.c     |    1 +
 drivers/net/mlx4/main.c             |    1 +
 drivers/pci/pci-sysfs.c             |    2 +-
 11 files changed, 102 insertions(+), 38 deletions(-)

---------------

David Rientjes (1):
      driver core: numa: fix BUILD_BUG_ON for node_read_distance

Greg Kroah-Hartman (3):
      sysfs: fix sysfs lockdep warning in ipmi code
      sysfs: fix sysfs lockdep warning in infiniband code
      sysfs: fix sysfs lockdep warning in mlx4 code

Jani Nikula (1):
      driver-core: document ERR_PTR() return values

Jiri Kosina (1):
      sysfs: use sysfs_bin_attr_init in firmware class driver

Magnus Damm (1):
      Driver core: Early platform kernel-doc update

Mel Gorman (1):
      sysfs: Initialised pci bus legacy_mem field before use

Randy Dunlap (1):
      driver-core: fix missing kernel-doc in firmware_class

Robert P. J. Day (2):
      kobject: documentation: Fix erroneous example in kobject doc.
      kobject: documentation: Update to refer to kset-example.c.

Stephen Rothwell (1):
      sysdev: the cpu probe/release attributes should be sysdev_class_attributes

