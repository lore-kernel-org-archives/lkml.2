Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab1CHXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:09:56 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:47526 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1CHXJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:09:55 -0500
Subject: [PATCH 0/2] hpsa: add sysfs host attribute to indicate whether
	reset_devices is honored 
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 08 Mar 2011 17:09:52 -0600
Message-ID: <20110308230749.22291.56200.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Redhat's request, this adds a sysfs host attribute to indicate whether
the reset_devices kernel parameter can be honored by the device.  This enables 
kexec tools to warn the user if they attempt to designate a non-resettable device
as the dump device.  If the device is not resettable, kdump won't work.

---

Stephen M. Cameron (2):
      hpsa: move device attributes to avoid forward declarations
      hpsa: export resettable_on_kexec host attribute


 drivers/scsi/hpsa.c |  276 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 152 insertions(+), 124 deletions(-)

-- 
-- steve
