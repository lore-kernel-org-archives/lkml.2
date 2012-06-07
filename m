Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab2FGEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:16:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2FGEQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:16:55 -0400
Message-Id: <20120607040339.727998529@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:59 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 23/82] NFSv4: Map NFS4ERR_SHARE_DENIED into an EACCES error instead of EIO
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit fb13bfa7e1bcfdcfdece47c24b62f1a1cad957e9 upstream.

If a file OPEN is denied due to a share lock, the resulting
NFS4ERR_SHARE_DENIED is currently mapped to the default EIO.
This patch adds a more appropriate mapping, and brings Linux
into line with what Solaris 10 does.

See https://bugzilla.kernel.org/show_bug.cgi?id=43286

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -101,6 +101,8 @@ static int nfs4_map_errors(int err)
 	case -NFS4ERR_BADOWNER:
 	case -NFS4ERR_BADNAME:
 		return -EINVAL;
+	case -NFS4ERR_SHARE_DENIED:
+		return -EACCES;
 	default:
 		dprintk("%s could not handle NFSv4 error %d\n",
 				__func__, -err);


