Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab1CAQII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:08:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1CAQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:08:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=eQGoLrFEOPrHWgq/jzFhv8dKzls7IyAR9tlmmcXJuFWwoj0UT1QjevIZa8Ru50A/CF
         RtjOzg/vp84czOFJeSUuRSvTJ+lCZahiSXRw2mXMtXx95jM7028G5PbWBDotmdBAO5kN
         RKPtS5Q6jvI0hhWvW4WKuANJqoNPHIwaPSqA0=
MIME-Version: 1.0
Date: Wed, 2 Mar 2011 00:08:06 +0800
Message-ID: <AANLkTi=2r1pzBXiYjZifKrWFUXcUtNE3nBwspRM37DYx@mail.gmail.com>
Subject: [2.6.38-rc6, patch] fix delayed_refs locking on error path...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly unlock delayed_refs in the error case.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1aa8d6..c48d699 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2787,6 +2787,7 @@ static int btrfs_destroy_delayed_refs(struct
btrfs_transaction *trans,
 	spin_lock(&delayed_refs->lock);
 	if (delayed_refs->num_entries == 0) {
 		printk(KERN_INFO "delayed_refs has NO entry\n");
+		spin_unlock(&delayed_refs->lock);
 		return ret;
 	}

-- 
Daniel J Blueman
