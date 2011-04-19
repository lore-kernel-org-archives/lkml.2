Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1DSLmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:42:33 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:47821 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab1DSLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:41:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, greg@kroah.com, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 0/3 V3] Introduce strtobool (previously usr_strtobool).
Date: Tue, 19 Apr 2011 12:43:44 +0100
Message-Id: <1303213427-12798-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <a>
References: <a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Third pass at introducing a new function to unify code that
is attempting to get a Boolean value from user input strings.

Rusty made the point that the usr_ in V2 implied user pointers, which
these aren't.  Hence the usr_ prefix has been dropped.  The naming
is still distinct enough from kstrtox to avoid any implication that
this function has the same tight parameter passing that those
functions have.

Use cases are the two converted here and numerous Boolean attributes in
sysfs. It is for the sysfs use cases that I'm interested, but Greg KH
pointed out a good start would be to unify these two, so that is
what we have here.

Jonathan Cameron (3):
  Add a strtobool function matching semantics of existing in kernel
    equivalents
  debugfs: move to new strtobool
  params.c: Use new strtobool function to process boolean inputs

 fs/debugfs/file.c      |   17 ++++-------------
 include/linux/string.h |    1 +
 kernel/params.c        |   14 ++++----------
 lib/string.c           |   29 +++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 23 deletions(-)

-- 
1.7.3.4

