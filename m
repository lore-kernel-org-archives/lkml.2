Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab2D3F6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:58:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41347 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2D3F6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:58:51 -0400
Date: Mon, 30 Apr 2012 15:58:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: linux-next: build failure after merge of the final tree (net-next
 tree related)
Message-Id: <20120430155836.44bcf3846c80cf686bb9cb77@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__30_Apr_2012_15_58_36_+1000_0DNPLrMHO_FxEYW8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Apr_2012_15_58_36_+1000_0DNPLrMHO_FxEYW8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

net/l2tp/l2tp_core.c: In function 'l2tp_verify_udp_checksum':
net/l2tp/l2tp_core.c:464:7: error: implicit declaration of function 'csum_i=
pv6_magic' [-Werror=3Dimplicit-function-declaration]

Caused by commit d2cf3361677e ("net/l2tp: add support for L2TP over IPv6
UDP").  Include file missing.

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Apr_2012_15_58_36_+1000_0DNPLrMHO_FxEYW8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPnioMAAoJEECxmPOUX5FEtLgP/iJ+VneztJSwWoM4+YLUIcxG
qG8QhVHbkb35aO2nH1fdIExCIV0MXxKJvQiNe9+0OLVnScfAofrSW2+3yscR8dzC
0YgHLddOJL7Njgg6JzTUDtQXH9d0ibK2Wppz27K5EITsCrfF8L2M75q961mM1xUy
J+IxLJk9743y/dXhovjD4Or2zJKYZGptT3E3VdSyvFTMA0Ug2PDS1wPMi3BNFWid
dyavUJD1HA9OZnIoeMG0azT3YuJElhNmmwvfCZF/Al0Jhp4S6lkY9Fvqu50K2gFA
rHlusDjPJ/Sl/bhem4TjOFp5I+DTC1rNmgQ6/HJq2DxdPwfYCiB4I/aHqIkEp9OL
x5wfXIuOjQmRAOB/fl0hXL9VkhyiTSk76hYWmlfgVL0XdUz722fV1xJ+SslLUJRC
kWRZspn/BdRjHC8Pwsh3ViHlPoOhNzlbCl0MOEPAxL1fO+xenQQDfXzZutTDtPMV
cWonDFn/9SiFh3DOAtE2qQduEyQtkY947fWOKgnP6j0iM+Elw/4277Fzf98+5mGZ
fSSjOP7QUfofMFo2FK/YtQCjSHy+h/L2SxuxIcHZMioQ1ACKyRw8X2h9HBEv7OSm
lZ+n+3ppsVRl2PP2Ok5yRi++X0xC6IfCky8OWx+HjIkfewJPg24UKKKDWfY9LoqW
uHEOYAdvtZHuRsNSndvw
=tMh/
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Apr_2012_15_58_36_+1000_0DNPLrMHO_FxEYW8--
