Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1BJGMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:12:19 -0500
Received: from sous-sol.org ([216.99.217.87]:45007 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751372Ab1BJGMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:12:15 -0500
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        chrisw@sous-sol.org
Subject: [PATCH 0/2] pci: refer to LSM when accessing device dependent config space
Date: Wed,  9 Feb 2011 22:11:50 -0800
Message-Id: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short patch series to make sure LSM gets visibility into attempt to
access device dependent config space.  Fixes a buglet I introduced in
de139a3 ("pci: check caps from sysfs file open to read device dependent
config space")

Chris Wright (2):
  security: add cred argument to security_capable()
  pci: use security_capable() when checking capablities during config
    space read

 drivers/pci/pci-sysfs.c  |    3 ++-
 include/linux/security.h |    6 +++---
 kernel/capability.c      |    2 +-
 security/security.c      |    5 ++---
 4 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.7.3.4
