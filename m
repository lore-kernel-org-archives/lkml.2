Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab1BKHiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:38:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:40069 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1BKHiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:38:08 -0500
Date: Fri, 11 Feb 2011 18:37:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem fixes for 2.6.38
Message-ID: <alpine.LRH.2.00.1102111831240.29250@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following fixes:

The TPM patch fixes a regression introduced in 2.6.38-rc3.  The 
security_capable() patches fix a bug introduced in de139a3, and ensures 
that access to PCI configuration space happens via LSM and audit.


The following changes since commit d2478521afc20227658a10a8c5c2bf1a2aa615b3:
  Corey Minyard (1):
        char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Chris Wright (2):
      security: add cred argument to security_capable()
      pci: use security_capable() when checking capablities during config space read

James Morris (1):
      Merge branch 'for-james' of git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd into for-linus

Stefan Berger (1):
      tpm_tis: Use timeouts returned from TPM

 drivers/char/tpm/tpm.c     |   18 ++++++++++++++++--
 drivers/char/tpm/tpm.h     |    2 ++
 drivers/char/tpm/tpm_tis.c |    4 +++-
 drivers/pci/pci-sysfs.c    |    3 ++-
 include/linux/security.h   |    6 +++---
 kernel/capability.c        |    2 +-
 security/security.c        |    5 ++---
 7 files changed, 29 insertions(+), 11 deletions(-)

-- 
James Morris
<jmorris@namei.org>
