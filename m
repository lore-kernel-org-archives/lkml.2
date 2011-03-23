Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1CWNiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:38:07 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:57165 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab1CWNiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:38:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 0/3] Introduce kstrtobool function
Date: Wed, 23 Mar 2011 13:39:11 +0000
Message-Id: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

This is an initial stab at a simple utility function intended to pin
down what the kernel considers to be 'true' and 'false'.  My original
query was centered around processing of sysfs inputs but as Greg
pointed out there are a couple of other places in kernel where this
functionality would be useful.

Given my main targets are in staging:iio I will provide patches for them
if/when people are happy with what we have here.

I obviously need to add some documentation, but want to get some
quick opinions on whether this is a good idea.

If the concept is fine the obvious questions are:

1) Function naming - this is only tangentially similar to kstrto* so
   is that a sensible location
2) Other values people think should be true or false.

Thanks,

Jonathan

Jonathan Cameron (3):
  Add a kstrtobool function matching semantics of existing in kernel
    equivalents.
  debugfs: move to new kstrtobool function
  params.c: Use new kstrtobool implementation to processing boolean
    inputs.

 fs/debugfs/file.c      |   19 ++++++-------------
 include/linux/kernel.h |    1 +
 kernel/params.c        |   15 ++++-----------
 lib/kstrtox.c          |   18 ++++++++++++++++++
 4 files changed, 29 insertions(+), 24 deletions(-)

-- 
1.7.3.4

