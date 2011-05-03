Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1ECUJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:09:33 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:3416 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1ECUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:09:31 -0400
Subject: [PATCH 00/16] hpsa: May 3, 2011 updates
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:58:44 -0500
Message-ID: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series mostly contains fixes to improve kdump behavior
and esp. to make older controllers which cannot be hard reset work by
doing a soft reset instead.   There are a few patches factoring out
various functionality into individual functions make way for the soft
reset functionality.  There is also a bugfix which prevents PCI write
combining from potentially causing commands to get lost. 

---

Stephen M. Cameron (16):
      hpsa: do readl after writel in main i/o path to ensure commands don't get lost.
      hpsa: add readl after writel in interrupt mask setting code
      hpsa: remove unused parameter from hpsa_complete_scsi_command()
      hpsa: delete old unused padding garbage
      hpsa: do a better job of detecting controller reset failure
      hpsa: wait longer for no-op to complete after resetting controller
      hpsa: factor out cmd pool allocation functions
      hpsa: factor out irq request code
      hpsa: increase time to wait for board reset
      hpsa: clarify messages around reset behavior
      hpsa: remove atrophied hpsa_scsi_setup function
      hpsa: use new doorbell-bit-5 reset method
      hpsa: do soft reset if hard reset is broken
      hpsa: remove superfluous sleeps around reset code
      hpsa: do not attempt PCI power management reset method if we know it won't work.
      hpsa: add P2000 to list of shared SAS devices


 drivers/scsi/hpsa.c     |  494 ++++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/hpsa.h     |   15 +
 drivers/scsi/hpsa_cmd.h |   11 -
 3 files changed, 412 insertions(+), 108 deletions(-)

-- 
-- steve
