Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431Ab1FWUhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:37:50 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:45394 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933927Ab1FWUht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:37:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=aqbhQqKVC1l2Zs+t4fKcY9+gB4rUlz5DGVLtcdSwfu8hDMQrXBXlGlYjzRb2dNjjKdmuAycNl37AydgFAKNRWwMXX1k3dKtH6qy9Q7CqDIOc3kr1JaaKLXmgsAPVaTPt;
Date: Thu, 23 Jun 2011 13:37:40 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20110623133740.0cdaf204@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
af0d6a0a3a30946f7df69c764791f1b0643f7cd6:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-06-01 02:07:22 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just a few minor fixes.  We have one open issue with the resource
re-allocation code that was re-added.  Ram has a fix but I'm concerned
it will introduce other regressions.  So at this point we have a few
options:
  - revert the bridge resource re-allocation code (again)
  - hide the re-allocation code behind a new kernel option (and not
    try=!), this would at least let us experiment with new strategies
    and PNP resource tracking etc
  - apply Ram's patch and revert it all later if things are still broken

The last option gets us the most coverage, but it's a bit late in the
cycle to be experimenting like this...

David S. Miller (1):
      PCI: Fix warning in drivers/pci/probe.c on sparc64

Márton Németh (1):
      x86/PCI/ACPI: fix type mismatch

Randy Dunlap (1):
      PCI: fix new kernel-doc warning

 arch/x86/pci/acpi.c |    2 +-
 drivers/pci/pci.c   |    2 +-
 drivers/pci/probe.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
