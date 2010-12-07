Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0LGXRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 18:17:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0LGXRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 18:17:32 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu,
        sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, James.Bottomley@suse.de,
        konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net,
        rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
Subject: [RFC PATCH 0/3] differentiate between I/O errors
Date: Tue,  7 Dec 2010 18:16:39 -0500
Message-Id: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20101130225956.GA8882@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refreshed Hannes' initial "scsi: Detailed I/O errors" patch against
v2.6.37-rc5.  v2 introduces __scsi_error_from_host_byte to avoid
the duplicate switch statement.  Also a few whitespace and comment
changes.

Split DM mpath change out to separate v2 patch; failed discard is now
retryable in the face of a non-target IO error.

Added improved block layer's I/O error message (based on the finer
grained I/O error returns afforded by SCSI).

Comments/suggestions are welcome.

Thanks,
Mike

Hannes Reinecke (1):
  scsi: Detailed I/O errors

Mike Snitzer (2):
  dm mpath: propagate target I/O errors immediately
  block: improve detail in I/O error messages

 block/blk-core.c          |   12 +++++++++---
 drivers/md/dm-mpath.c     |   11 +----------
 drivers/scsi/scsi_error.c |   24 +++++++++++++++++-------
 drivers/scsi/scsi_lib.c   |   24 ++++++++++++++++++++++--
 include/scsi/scsi.h       |    3 +++
 5 files changed, 52 insertions(+), 22 deletions(-)

-- 
1.7.2.3

