Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1CXNWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:22:34 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:33509 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab1CXNWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:22:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [RFC PATCH 0/3 V2] Introduce usr_strtobool (previously kstrtobool)
Date: Thu, 24 Mar 2011 13:23:42 +0000
Message-Id: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a second pass at introducing a new function to unify
code that is attempting to get a boolean value from user input strings.

The first attempt (other than having some stupid bugs) was opposed by
Alexy Dobriyan on the basis that it did completely insufficient checking
on the string.  Given that under the original proposed name it was
associated with the other kstrto* functions it was reasonable to assume
if would be as strict as they are.  Hence the name change to remove
an implication of this.

The use cases are both the pair below and the numerous boolean
attributes in sysfs.  It's for these that I'm personally interested
in having such a function, but as Greg pointed out a good starting
point is to unify the places where this is already occuring.

The big questions to my mind are:

1) Is the usr_strtobool name a good choice?
2) Should we introduce other acceptable boolean inputs?
   Clearly there are issues in changing the list as it will at least
   in theory change the two api's effected by this series.

Thanks,

Jonathan

Jonathan Cameron (3):
  Add a usr_strtobool function matching semantics of existing in kernel
    equivalents
  debugfs: move to new usr_strtobool
  params.c: Use new usr_strtobool function to process boolean inputs

 fs/debugfs/file.c      |   20 ++++++--------------
 include/linux/string.h |    1 +
 kernel/params.c        |   14 ++++----------
 lib/string.c           |   29 +++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 24 deletions(-)

-- 
1.7.3.4

