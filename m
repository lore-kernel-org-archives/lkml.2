Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0LVR1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:27:09 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46934 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069Ab0LVR1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:27:07 -0500
Subject: Boot failure with block/for-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 11:27:03 -0600
Message-ID: <1293038823.3019.89.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to test out the SCSI post merge tree, I've found it won't boot on
my SCSI test system.  The reason is a failure to read the partition
table of the root disc.  It just gives

sda: unable to read partition table

The other four discs in the system seem to read their partition tables
OK.

The obvious candidate is the partition code rework in block/for-next.
Simply reverting 

commit d2bf1b6723ed0eab378363649d15b7893bf14e91
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Dec 8 20:57:36 2010 +0100

    block: move register_disk() and del_gendisk() to block/genhd.c
 
Doesn't fix the boot failure, so it's obviously something deeper.

James


