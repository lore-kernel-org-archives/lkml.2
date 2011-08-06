Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1HFAIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:08:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab1HFAIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:08:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:49 2011
Message-Id: <20110806000249.473446279@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:01:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Adamson <andros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [06/55] NFSv4.1: update nfs4_fattr_bitmap_maxsz
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Adamson <andros@netapp.com>

commit e5012d1f3861d18c7f3814e757c1c3ab3741dbcd upstream.

Attribute IDs assigned in RFC 5661 now require three bitmaps.
Fixes hitting a BUG_ON in xdr_shrink_bufhead when getting ACLs.

Signed-off-by: Andy Adamson <andros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -88,7 +88,7 @@ static int nfs4_stat_to_errno(int);
 #define encode_getfh_maxsz      (op_encode_hdr_maxsz)
 #define decode_getfh_maxsz      (op_decode_hdr_maxsz + 1 + \
 				((3+NFS4_FHSIZE) >> 2))
-#define nfs4_fattr_bitmap_maxsz 3
+#define nfs4_fattr_bitmap_maxsz 4
 #define encode_getattr_maxsz    (op_encode_hdr_maxsz + nfs4_fattr_bitmap_maxsz)
 #define nfs4_name_maxsz		(1 + ((3 + NFS4_MAXNAMLEN) >> 2))
 #define nfs4_path_maxsz		(1 + ((3 + NFS4_MAXPATHLEN) >> 2))


