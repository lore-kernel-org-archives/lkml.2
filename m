Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2JHAtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 20:49:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53565 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2JHAtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:49:13 -0400
Date: Mon, 8 Oct 2012 11:49:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: manual merge of the modules tree with Linus' tree
Message-Id: <20121008114904.8c920933bfdf81a8e0c70647@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Oct_2012_11_49_04_+1100_ai468y0OUqWp5qgX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Oct_2012_11_49_04_+1100_ai468y0OUqWp5qgX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the modules tree got a conflict in
init/Kconfig between commit 754b7b63d112 ("sections: disable const
sections for PA-RISC v2") from Linus' tree and commit 54ddd23d78ba
("X.509: Add simple ASN.1 grammar compiler") from the modules tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

BTW, Rusty, that commit from the modules tree has no SOB from you even
though you committed it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc init/Kconfig
index ed6334d,abc6e63..0000000
--- a/init/Kconfig
+++ b/init/Kconfig
@@@ -1582,10 -1672,12 +1642,18 @@@ config PADAT
  	depends on SMP
  	bool
 =20
 +# Can be selected by architectures with broken toolchains
 +# that get confused by correct const<->read_only section
 +# mappings
 +config BROKEN_RODATA
 +	bool
 +
+ config ASN1
+ 	tristate
+ 	help
+ 	  Build a simple ASN.1 grammar compiler that produces a bytecode output
+ 	  that can be interpreted by the ASN.1 stream decoder and used to
+ 	  inform it as to what tags are to be expected in a stream and what
+ 	  functions to call on what tags.
+=20
  source "kernel/Kconfig.locks"

--Signature=_Mon__8_Oct_2012_11_49_04_+1100_ai468y0OUqWp5qgX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQciMAAAoJEECxmPOUX5FEamEP/jehudmz7wk13z8VLysNnE3I
mZp/p3EsJnlU2vJXFWwXtxGtX6g8V9+q1dlKOyQOEIW7iqhF7AXb8S77pbXlPCZk
KY09uUk2RwUyxs+v9WMSKVFlDzCpJ/ZNfbeW8+cH7AXqxDxDs+mdW0scrBikifdQ
M6eB0uU8lAF6wbY+8/ZYJWG+iBLIPPI+KF3PnxIQ2v/XOBEXFlX8+DhA5r9olZX3
Y4UzcCquoyhWW/QNmDLdRwr55ZPUWZoRRclXC4EtZgOGV5BK5SAjPM72rPYpEY+P
Kmck0E7iHHZKxvHFJQU5XJ9w9ONSrzdwgrWNXACmC++1kH5J+VQRr0Mk6AASmPtu
3hGvfdGoES+En562iGRGAlrHAb0tettueFWra7dA/KYzBRht6H8mDVdx5iO82qi7
u5Fcx+M6Eyo3RX/IoLWjVm49jIfSE8CJ43C1mlHP6I9O+6Q7EhK7IaZ6NibbpHGg
CH5EwVcWN/ddG2GX7kNacJlWrThr6saMV528uBx93q3qH+zO7wCgVhr9G3UP8C4I
a5fJcIwGQI/oAYS3bBP0mTTHnZNmV1/cZFiP7xwZGJxBN4dqkbxSlxgMKX+IE66m
q8zTlebar2w+h6vjexInDKEAtt60IIGrndaGSd0PbxJNFdwqLb9Tx3V19vD5o6kn
9VwoKHVEelDLihO1j2yU
=1dly
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Oct_2012_11_49_04_+1100_ai468y0OUqWp5qgX--
