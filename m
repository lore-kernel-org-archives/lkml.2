Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1HQKJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:09:08 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:58108 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1HQKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:09:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: greg@kroah.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 0/2] Sysfs group create for empty groups.
Date: Wed, 17 Aug 2011 11:17:00 +0100
Message-Id: <1313576222-27743-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a quick stab at avoiding a hideous work around
we are currently using in IIO.  In some cases we have entire
attribute groups that are created from descriptions an array
of struct iio_chan_spec.  To keep the reference counts sane
and cause subdirectories to be created we are currently using
dummy groups and dummy attribute arrays (provided once in the
core).  This series is an initial probably stupid approach
to avoiding this.

Greg has expressed some doubts about whether subdirectories are
ever a good idea, but the problem occurs for the top level
directory as well (handled by patch 1).

Note, all attributes are created at probe time.  Ultimately we
are just respinning the create_group code to allow us to create
the attributes from a device description rather than statically
allocating them in each driver (results in a massive reduction
in repeated code).

All opinions welcomed.

(this is definitely an rfc, the code isn't even tested yet)

Jonathan

p.s. Greg, sorry for pestering about this!

Jonathan Cameron (2):
  sysfs: Allow for null group pointer in create_group
  sysfs: Allow for groups with no attributes - grp->attrs = NULL.

 fs/sysfs/group.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

-- 
1.7.3.4

