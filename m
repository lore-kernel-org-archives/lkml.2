Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1BOVcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:32:50 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:16727 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab1BOVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:32:46 -0500
Subject: [PATCH 0/6] hpsa: Feb 15, 2011 updates 
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mike.mikem@beardog.cce.hp.com, thenzl@redhat.com,
        akpm@linux-foundation.org, smcameron@yahoo.com
Date: Tue, 15 Feb 2011 15:32:42 -0600
Message-ID: <20110215212856.5407.3438.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a problem that commands were unintentionally
re-ordered within the driver, and another problem that the hpsa_simple_mode
module paramter didn't actually work.  It adds a host attribute in /sys to
know which mode (simple or performant) the controller is in.  It informs the
controller that we're only using 32-bit tags (needed for a couple of new
controllers to work properly).  Finally, we shouldn't proceed with kdumping
if a controller cannot be reset, as there may be outstanding commands which
interfere with kdump's i/o.

---

Dan Carpenter (1):
      hpsa: fix bad comparison

Stephen M. Cameron (5):
      hpsa: do not re-order commands in internal queues
      hpsa: make hpsa.hpsa_simple_mode=1 module parameter actually work
      hpsa: Add transport_mode host attribute in /sys
      hpsa: Inform controller we are using 32-bit tags.
      hpsa: Do not attempt kdump if we detect resetting controller failed.


 Documentation/scsi/hpsa.txt |    5 ++
 drivers/scsi/hpsa.c         |  104 +++++++++++++++++++++++++++----------------
 drivers/scsi/hpsa.h         |    5 +-
 drivers/scsi/hpsa_cmd.h     |    3 +
 4 files changed, 75 insertions(+), 42 deletions(-)

-- 
-- steve
