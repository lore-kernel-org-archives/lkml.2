Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab0KORpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:45:46 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:39066 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933227Ab0KORpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:45:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=k+I2fARpWGNUV3QE1tQYGZsn/mT+3rhh3xvk0MjSB9UEBckikCn/sBt2MCdMnrHr8p3BW+NQ6K/WBw1PNnTIfaIgonN5rYNO/zIkjicgFjml5nYbzP7XFyacaLVH4tCq;
Date: Mon, 15 Nov 2010 09:45:27 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20101115094527.49464ed2@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
f6614b7bb405a9b35dd28baea989a749492c46b2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2010-11-09 10:34:48 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

There's one very recent commit in here, but it's just a warning fix
from Randy so should be ok.

This set includes a fix for a long standing mmap issue on /proc/bus/pci
(present since we added the map range checking during that e1000 EEPROM
fire drill) and a fix from Bjorn for a recent resource handling
regression.  It also adds a little code to better handle device power
states at enable time; rather than assuming device state is unknown at
enable time (which will prevent us from configuring things like MSI),
we read the current state out of the device if possible, fixing some
network and gfx related bugs in the process.

Bjorn Helgaas (2):
      x86/PCI: coalesce overlapping host bridge windows
      PCI: fix pci_bus_alloc_resource() hang, prefer positive decode

Jesse Barnes (1):
      PCI: read current power state at enable time

Martin Wilck (1):
      PCI: fix size checks for mmap() on /proc/bus/pci files

Randy Dunlap (1):
      PCI: sysfs: fix printk warnings

Steven Rostedt (1):
      PCI hotplug: ibmphp: Add check to prevent reading beyond mapped area

 arch/x86/pci/acpi.c               |  103 +++++++++++++++++++++++++++++-------
 drivers/pci/bus.c                 |   70 +++++++++++++++++--------
 drivers/pci/hotplug/ibmphp_ebda.c |    6 ++
 drivers/pci/pci-sysfs.c           |   23 ++++++--
 drivers/pci/pci.c                 |   12 ++++
 drivers/pci/pci.h                 |    7 ++-
 drivers/pci/proc.c                |    2 +-
 7 files changed, 174 insertions(+), 49 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
