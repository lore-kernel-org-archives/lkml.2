Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab0G3TRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:17:07 -0400
Received: from kroah.org ([198.145.64.141]:46234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755836Ab0G3RR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:01 2010
Message-Id: <20100730171501.287397710@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [018/165] NFSv4: Ensure that /proc/self/mountinfo displays the minor version number
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 0be8189f2c87fcc747d6a4a657a0b6e2161b2318 upstream.

Currently, we do not display the minor version mount parameter in the
/proc mount info.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/super.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -534,6 +534,22 @@ static void nfs_show_mountd_options(stru
 	}
 }
 
+#ifdef CONFIG_NFS_V4
+static void nfs_show_nfsv4_options(struct seq_file *m, struct nfs_server *nfss,
+				    int showdefaults)
+{
+	struct nfs_client *clp = nfss->nfs_client;
+
+	seq_printf(m, ",clientaddr=%s", clp->cl_ipaddr);
+	seq_printf(m, ",minorversion=%u", clp->cl_minorversion);
+}
+#else
+static void nfs_show_nfsv4_options(struct seq_file *m, struct nfs_server *nfss,
+				    int showdefaults)
+{
+}
+#endif
+
 /*
  * Describe the mount options in force on this server representation
  */
@@ -595,11 +611,9 @@ static void nfs_show_mount_options(struc
 
 	if (version != 4)
 		nfs_show_mountd_options(m, nfss, showdefaults);
+	else
+		nfs_show_nfsv4_options(m, nfss, showdefaults);
 
-#ifdef CONFIG_NFS_V4
-	if (clp->rpc_ops->version == 4)
-		seq_printf(m, ",clientaddr=%s", clp->cl_ipaddr);
-#endif
 	if (nfss->options & NFS_OPTION_FSCACHE)
 		seq_printf(m, ",fsc");
 }


