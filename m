Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966Ab2LGCpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:45:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36107 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2LGCpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:45:01 -0500
Date: Fri, 7 Dec 2012 13:44:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20121207134452.386f14bc82d0373987e17e88@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Dec_2012_13_44_52_+1100_QMPGO4mzCXWPFpMV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Dec_2012_13_44_52_+1100_QMPGO4mzCXWPFpMV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
block/blk-exec.c between commit 893d290f1d74 ("block: Don't access
request after it might be freed") from Linus' tree and commit
c246e80d8673 ("block: Avoid that request_fn is invoked on a dead queue")
from the block tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc block/blk-exec.c
index f71eac3,1320e74..0000000
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@@ -77,8 -71,8 +77,8 @@@ void blk_execute_rq_nowait(struct reque
  	__elv_add_request(q, rq, where);
  	__blk_run_queue(q);
  	/* the queue is stopped so it won't be run */
 -	if (rq->cmd_type =3D=3D REQ_TYPE_PM_RESUME)
 +	if (is_pm_resume)
- 		q->request_fn(q);
+ 		__blk_run_queue_uncond(q);
  	spin_unlock_irq(q->queue_lock);
  }
  EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);

--Signature=_Fri__7_Dec_2012_13_44_52_+1100_QMPGO4mzCXWPFpMV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQwVgkAAoJEECxmPOUX5FE/wsQAIu8GtTNAzu+ihsWobX85vnj
HwxxleghsRj8kT+KZnX5pkTW8DUy9tnsgmWgIfRRaQeW1XqpVW2FLvDWsWimZ9pH
gC0ybauKGxgG3XiExr//EVVIEHkEtKyThi6rgu6yEpZxwC1lCJCb8xdjHH9ViEd9
//c7M3GQXvOoWklIFDDlbCwcLOrtUqJDe5i1lkpj47FajraVe0Z/sIwwkT94Gamh
Q2VFLAe/J8OoacFbTb2saoD+cErsh1Z2EzaT3JtT+OlLUXlO+QsdIVm1pfukYjiB
VnbJ8htxmL20LQ5Xmp/SGXoKzN5QGoVk5WyMfDxsEdeYa2qoJRWakY+3WvlS5xb5
0lOdc6sI5iI3PrcyilZMymPy2UcZRzIo0OJR78L9aUTxFeCc4yL8ZCLkwgdpqMqA
JXn6skJPvKNPkW5s6tMjei1kWbCNgRq9K7NhCK0sLm4/wRf8MNLze/GIL9m4Hr7W
vqpHWB7497G4jgUABOINv0GaGEgzP12VNGp6PXNOKNaxwxHZ1pJzmgtaYyEv8BQW
zjOcn3VUA5XreoJPjlancmkJPWhZzFXbtlOCqLktbJdJDcoNg+bq245JTRY0XJV6
Fzq8dVLIiDDnuUcSU4nwAybaOoX/rBkB6OaQeIwUXajE1zYaSbn27Sb5LrqQr3rd
LESHWPFxRbSzHAJDSNwo
=ATRW
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Dec_2012_13_44_52_+1100_QMPGO4mzCXWPFpMV--
