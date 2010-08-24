Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab0HXXCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:02:20 -0400
Received: from kroah.org ([198.145.64.141]:41007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab0HXXCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:04 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:04 2010
Message-Id: <20100824224504.580704332@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick LoPresti <lopresti@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [038/114] nfs: Add "lookupcache" to displayed mount options
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick J. LoPresti <lopresti@gmail.com>

commit 9b00c64318cc337846a7a08a5678f5f19aeff188 upstream.

Running "cat /proc/mounts" fails to display the "lookupcache" option.
This oversight cost me a bunch of wasted time recently.

The following simple patch fixes it.

Signed-off-by: Patrick LoPresti <lopresti@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
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


