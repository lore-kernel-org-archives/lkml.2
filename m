Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab0JUAjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:39:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57973 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab0JUAjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:39:10 -0400
Date: Thu, 21 Oct 2010 11:38:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20101021113858.f8b9849f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Oct_2010_11_38_58_+1100_lZ0Cwm97OIxfQW+j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Oct_2010_11_38_58_+1100_lZ0Cwm97OIxfQW+j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/dir.c: In function 'nfs_readdir_free_large_page':
fs/nfs/dir.c:475: error: implicit declaration of function 'vm_unmap_ram'
fs/nfs/dir.c: In function 'nfs_readdir_large_page':
fs/nfs/dir.c:496: error: implicit declaration of function 'vm_map_ram'
fs/nfs/dir.c:496: warning: assignment makes pointer from integer without a =
cast

Caused by commit b8aa6064474e186f598584508f9230d49a0004af ("NFS: readdir
with vmapped pages").  Forgot to include linux/vmalloc.h.  See Rule 1 (in
Documentation/SubmitChecklist).

I have used the nfs tree from next-20101020 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Oct_2010_11_38_58_+1100_lZ0Cwm97OIxfQW+j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMv4uiAAoJEDMEi1NhKgbs0z8IAIOUscWPppThufxIi36ZgJQX
gdVsMxhAU2Gyy4nROGeaE5FmTtBHHSZd632GbqcJosNOmS9UVydmIHJ4YlZrmGe3
K99iOt7drrg3iaF9fnWJi6N3eyQ4MY6RvG5iLbysKaJXjPqakeFxcLMQbxXnRz8q
GBXZTb8PD3KTxvMGDR8hK0uG7SqzBXcTiLq11hpJFnNlmPQIuf5csMUWEZ3l36CC
osJSGviIsUgLcGkkWxNzdb+T0axK2aJJlxP+wm8uq2MmmSZWuqSmFzmY5EWxwxwQ
oF51cOwa59TuC6Q7gKiWmhRGNRr6C2JwdxHhYzLLjesE5Ur8kwEB3d3TUy+lx9M=
=afGN
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Oct_2010_11_38_58_+1100_lZ0Cwm97OIxfQW+j--
