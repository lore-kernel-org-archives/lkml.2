Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0ECCJG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 22:09:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36064 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0ECCJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 22:09:03 -0400
Date: Mon, 3 May 2010 12:08:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20100503120847.e9328e75.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_May_2010_12_08_47_+1000_n.cQ3o_A7JLrLBy+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_May_2010_12_08_47_+1000_n.cQ3o_A7JLrLBy+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the net tree, today's linux-next build (x86_64
allmodconfig) failed like this:

net/sctp/socket.c: In function 'sctp_data_ready':
net/sctp/socket.c:6191: error: implicit declaration of function 'sk_has_sle=
eper'
net/sctp/socket.c:6192: error: 'struct sock' has no member named 'sk_sleep'

Caused by commit 43815482370c510c569fd18edb57afcb0fa8cab6 ("net:
sock_def_readable() and friends RCU conversion") interacting with commit
561b1733a465cf9677356b40c27653dd45f1ac56 ("sctp: avoid irq lock inversion
while call sk->sk_data_ready()") which entered Linus' tree on April 29.

I have used the net tree from next-20100430 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__3_May_2010_12_08_47_+1000_n.cQ3o_A7JLrLBy+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkveMC8ACgkQjjKRsyhoI8xU3ACfQZlEsx2RaLMFnQcWWTjuE252
XAMAoIgXRntVsXBN63fupS7DkMugi+Zv
=ytvm
-----END PGP SIGNATURE-----

--Signature=_Mon__3_May_2010_12_08_47_+1000_n.cQ3o_A7JLrLBy+--
