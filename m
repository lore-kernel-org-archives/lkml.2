Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab0HJSgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:36:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42911 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab0HJSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:cc:date:message-id:mime-version:content-type;
        b=wZIVRLjJ/YHttk6aTm3IK+P/HRVsPFE4sKeXyJQ6eUfTZgUMMyV2QmPexhz3GbqOgA
         DZeRDOVfJ/hEhUf4XaU6VwG2cCtgiTspHOKB9EQnDlOoKFnukjlv4TXTydc227iSOpkI
         XzsAnEs/s2CPchDcmrtvEK9cd7Ogf/3ClaexU=
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: linux-nfs@vger.kernel.org
Subject: [PATCH] nfs: Add "lookupcache" to displayed mount options
CC: linux-kernel@vger.kernel.org
Date: Tue, 10 Aug 2010 11:36:22 -0700
Message-ID: <87aaou48nt.fsf@patl.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running "cat /proc/mounts" fails to display the "lookupcache" option.
This oversight cost me a bunch of wasted time recently.

The following simple patch fixes it.

CC: stable <stable@kernel.org>
Signed-off-by: Patrick LoPresti <lopresti@gmail.com>

--- linux-2.6.35/fs/nfs/super.c~	2010-08-01 15:11:14.000000000 -0700
+++ linux-2.6.35/fs/nfs/super.c	2010-08-10 11:08:22.000000000 -0700
@@ -652,6 +652,13 @@ static void nfs_show_mount_options(struc
 
 	if (nfss->options & NFS_OPTION_FSCACHE)
 		seq_printf(m, ",fsc");
+
+	if (nfss->flags & NFS_MOUNT_LOOKUP_CACHE_NONEG) {
+		if (nfss->flags & NFS_MOUNT_LOOKUP_CACHE_NONE)
+			seq_printf(m, ",lookupcache=none");
+		else
+			seq_printf(m, ",lookupcache=pos");
+	}
 }
 
 /*
