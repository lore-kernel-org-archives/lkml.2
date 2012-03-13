Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab2CMJLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:11:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33727 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2CMJLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:11:00 -0400
Date: Tue, 13 Mar 2012 20:10:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the akpm tree with the powerpc tree
Message-Id: <20120313201030.c4730c816be21a7d053ffb90@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_20_10_30_+1100_YqIrAXTzdwC25Ovj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_20_10_30_+1100_YqIrAXTzdwC25Ovj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/powerpc/platforms/pseries/eeh_event.c between commit 29f8bf1b7f79
("powerpc/pseries: Cleanup comments in EEH aux components") from the
powerpc tree and commit "powerpc/eeh: remove eeh_event_handler()
->daemonize()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/platforms/pseries/eeh_event.c
index 4a47525,a6d33c8..0000000
--- a/arch/powerpc/platforms/pseries/eeh_event.c
+++ b/arch/powerpc/platforms/pseries/eeh_event.c
@@@ -56,10 -58,10 +56,10 @@@ DEFINE_MUTEX(eeh_event_mutex)
  static int eeh_event_handler(void * dummy)
  {
  	unsigned long flags;
 -	struct eeh_event	*event;
 -	struct pci_dn *pdn;
 +	struct eeh_event *event;
 +	struct eeh_dev *edev;
 =20
- 	daemonize("eehd");
+ 	set_task_comm(current, "eehd");
  	set_current_state(TASK_INTERRUPTIBLE);
 =20
  	spin_lock_irqsave(&eeh_eventlist_lock, flags);

--Signature=_Tue__13_Mar_2012_20_10_30_+1100_YqIrAXTzdwC25Ovj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXw8GAAoJEECxmPOUX5FEdyoP/RiqFASdJ98+72wU7zzAT7C8
0nUOZvDmq2YSUGhMz15J/JUHvOixKWSF9CWmH40zl0azyPdaxbYEofh0r4QhRye5
Jayc6Dc/2ytqGx9a7ENz3U9jzEb/y6vggHIt4Q6JomC45cmjVFNToVB4HMcPx6FJ
TPgTxHc18N/GMtMFuscQHsu4p8FHPDjBkJZgv0BBHMu7dikVVvDhgR4Wl5Z1d/QR
vZVtCJMQ+tsrYsgYU1L55WbOf7E5VU14t6bf/4VTzuoyXfS5F45HuX/Tm2Cylok3
mntllYA1w2xs+VDfgdu+vfVVylTOvTUrd/smGLmI6U47UBRMxm+lnW5DQpNnmyIr
VeBG0BYJr6l3WCeLQQITI8/rVDm9uMKKGHlMht5B1DtZ6MyLy9Or5cXO148jh/Es
ggqphdCIKMvbzNLczFUQNS4kQzkvrUnftmEnpcVbDJEZcJ/8a5hrzPc2mr84Emst
tZKLMSM/uXKeJUSOBywRDGfaRh+bm5jWKIRtma4uRlxmcobAyAoU5rz1PdMYHnvq
1NNKRGVVNzWM+/BhLY46blxEBTfM5wruy2BtL5XUOxcP+QhM9sJQ86LTDqEDiOMX
nR8dHV1rHB+trFYBCyDWxc2IAprZfdLJX4fsrqTdyas5zi7oy6F45RCoGOLaR26f
Pj4afg5ZKccwVaColiOv
=TncX
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_20_10_30_+1100_YqIrAXTzdwC25Ovj--
