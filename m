Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935814Ab0HFTOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:14:32 -0400
Received: from kroah.org ([198.145.64.141]:58484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935669Ab0HFS77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:59:59 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:34 2010
Message-Id: <20100806185834.089377858@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:56:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benny Halevy <bhalevy@panasas.com>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: [03/34] Re: acl trouble after upgrading ubuntu
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@fieldses.org>

commit d327cf7449e6fd5cbac784c641770e9366faa386 upstream.

Subject: [03/34] nfs: fix acl decoding

Commit 28f566942c6b1d929f5e240e69e7081b77b238d3 "NFS: use dynamically
computed compound_hdr.replen for xdr_inline_pages offset" accidentally
changed the amount of space to allow for the acl reply, resulting in an
IO error on attempts to get an acl.

Reported-by: Paul Rudin <paul@rudin.co.uk>
Cc: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -2096,7 +2096,7 @@ nfs4_xdr_enc_getacl(struct rpc_rqst *req, __be32 *p,
 	encode_compound_hdr(&xdr, req, &hdr);
 	encode_sequence(&xdr, &args->seq_args, &hdr);
 	encode_putfh(&xdr, args->fh, &hdr);
-	replen = hdr.replen + nfs4_fattr_bitmap_maxsz + 1;
+	replen = hdr.replen + op_decode_hdr_maxsz + nfs4_fattr_bitmap_maxsz + 1;
 	encode_getattr_two(&xdr, FATTR4_WORD0_ACL, 0, &hdr);
 
 	xdr_inline_pages(&req->rq_rcv_buf, replen << 2,


