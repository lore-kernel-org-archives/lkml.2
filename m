Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2AEGfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:35:34 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48986 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2AEGfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:35:31 -0500
Date: Thu, 5 Jan 2012 17:35:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org
Subject: linux-next: build warning after merge of the vfs tree
Message-Id: <20120105173521.9adbe29e16ca0e7361f79c36@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_17_35_21_+1100_ouhxGakfn4LtB2UQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_17_35_21_+1100_ouhxGakfn4LtB2UQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/reiserfs/super.c:701:2: warning: initialization from incompatible pointe=
r type [enabled by default]
fs/reiserfs/super.c:701:2: warning: (near initialization for 'reiserfs_sops=
.show_options') [enabled by default]

Caused by commit 2ddeb2a58b11 ("vfs: switch ->show_options() to struct
dentry *") interacting with commit f1823b7b87d1 ("reiserfs: Properly
display mount options in /proc/mounts") from the ext3.  This needs some
merge fix ... (and will probably currently cause crashes :-()

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_17_35_21_+1100_ouhxGakfn4LtB2UQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBUSpAAoJEECxmPOUX5FE9VIP/28QFn3dZieCy41w1MTbIMrg
5EApTNp4snVMkalq2o0A5/HL7QwEAfKXwjygMLLM1xWPoEr2c2T/4rqfjnKHMdcs
aGZoxYH+3Zk0dzoZn9qHRi6WQAaM8JKEocOYFSwxkmOBdKWUkm1Y22IFIhFYrw7o
vPs1P0mvZyNarxcZNwNoxbVqsorw1J0MlQnLKfRYn+eX6hA136cDYHLPDLmtO+Lf
vlYB95cMBOdpXtf4ZeYqkMfie5YJIBA3vxNYyDVYtxGkAItkF8PdyfhSWrTkXBrf
/AJjI/anjNupo8UuvzmDyazbDPcWv3/uWyZSQW/ubZkTVXHtvG0GnagLHAKP3kOD
+Q8fn8wEryVMHeCk/pGidkwojocuEmS1MdZDtNfkZlxWCmIrJg+RCPb0Fi9I8l3Z
ns54G49Vz3sEWZeoGtdaypPb9UxLgdI+93KahPQsRVK6xbGQ8sODJlp0TcI0qxt6
YySKvCRIS5PtINAFFO1GyZ14FbeOJs68X1X0Z2jqiBGDvjovVjCeC3EX0ffDccts
rnfQF3ulOLHVM0ZPH+H2yTGOJpQEINdiHoxfk+5gUaHLb1l87D01+XBW0DPhl3Au
UKMAnGRcGHQrn9nztKZEVcTUbzf+J8POA7/HrW3EETRiK6E6o4I+PfyvnVJHfeDE
7ihwuHX6RNaxE18Aa5xz
=Rsae
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_17_35_21_+1100_ouhxGakfn4LtB2UQ--
