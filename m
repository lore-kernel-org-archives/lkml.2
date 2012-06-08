Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464Ab2FHFHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:07:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43138 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759824Ab2FHFHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:11 -0400
Message-Id: <20120608041844.084930725@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 24/82] NFSv4: Map NFS4ERR_SHARE_DENIED into an EACCES error instead of EIO
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit fb13bfa7e1bcfdcfdece47c24b62f1a1cad957e9 upstream.

If a file OPEN is denied due to a share lock, the resulting
NFS4ERR_SHARE_DENIED is currently mapped to the default EIO.
This patch adds a more appropriate mapping, and brings Linux
into line with what Solaris 10 does.

See https://bugzilla.kernel.org/show_bug.cgi?id=43286

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index af2db2c..42d9e9c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -103,6 +103,8 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_BADOWNER:
 	case -NFS4ERR_BADNAME:
 		return -EINVAL;
+	case -NFS4ERR_SHARE_DENIED:
+		return -EACCES;
 	default:
 		dprintk("%s could not handle NFSv4 error %d\n",
 				__func__, -err);


