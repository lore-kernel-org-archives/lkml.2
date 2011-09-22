Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1IVOPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:15:25 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49792 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1IVOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:15:23 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjDEQEiPVxA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 0/2] reset xenstore watches to fix kexec in Xen PVonHVM guests
Date: Thu, 22 Sep 2011 16:14:47 +0200
Message-Id: <1316700889-3518-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following series improves kexec in a Xen PVonHVM guest.

It is available via git:

 git://github.com/olafhering/linux.git xen-kexec-XS_RESET_WATCHES-3.0

A new xenstored command XS_RESET_WATCHES has been added in
xen-unstable.hg changeset 23839:42a45baf037d. The command removes all
watches and transactions for the guest. The following patches make use
of the new command to wipe all existing watches during startup.

Olaf

Olaf Hering (2):
  xen/pv-on-hvm kexec: update xs_wire.h:xsd_sockmsg_type from
    xen-unstable
  xen/pv-on-hvm kexec: add xs_reset_watches to shutdown watches from
    old kernel

 drivers/xen/xenbus/xenbus_xs.c     |   13 +++++++++++++
 include/xen/interface/io/xs_wire.h |    6 +++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

-- 
1.7.3.4

