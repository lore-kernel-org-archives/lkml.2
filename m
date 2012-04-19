Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2DSFgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:36:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33812 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2DSFgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:36:00 -0400
Date: Thu, 19 Apr 2012 15:35:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the vhost tree with the net-next tree
Message-Id: <20120419153547.c9e4cf4865b28c61668a2be1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_15_35_47_+1000_Q5il6qlTH2XQdyBJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_15_35_47_+1000_Q5il6qlTH2XQdyBJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

Today's linux-next merge of the vhost tree got a conflict in
drivers/net/virtio_net.c between commit 586d17c5a01b ("virtio-net: send
gratuitous packets when needed") from the net-next tree and commit
66fdfb7bc203 ("virtio-net: remove useless disable on freeze") from the
vhost tree.

Just context changes.  I fixed it up (I think - see below) and can carry
the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/virtio_net.c
index fa58c78,3e4767f..0000000
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@@ -1224,16 -1183,6 +1224,11 @@@ static int virtnet_freeze(struct virtio
  {
  	struct virtnet_info *vi =3D vdev->priv;
 =20
 +	/* Prevent config work handler from accessing the device */
 +	mutex_lock(&vi->config_lock);
 +	vi->config_enable =3D false;
 +	mutex_unlock(&vi->config_lock);
 +
- 	virtqueue_disable_cb(vi->rvq);
- 	virtqueue_disable_cb(vi->svq);
- 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ))
- 		virtqueue_disable_cb(vi->cvq);
-=20
  	netif_device_detach(vi->dev);
  	cancel_delayed_work_sync(&vi->refill);
 =20

--Signature=_Thu__19_Apr_2012_15_35_47_+1000_Q5il6qlTH2XQdyBJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj6QzAAoJEECxmPOUX5FENJQP/izC2AzzEJFPf4Zr2GY+1nxA
Qa3SlpZO96xvQmHR5scjuvAuNgZF5M27/Nu9UmZ95Een7JoGU/fBhi+F8woTYqn+
Vv//49n0yCQC/zQuyEFiI6NJr6PoBvhcpVHXZu803l4Vk1Uk5uOwg7ywNXB9Csp2
aT27l1s/gVM24wp1iWzcsTZCVf/HQB79GuSbuwQ9+KPcY4Ma1Hg0e63lah5DZgKT
5GleaqI+vPZsQr4Hn/O4xodHyMfSaDtSMAdsHP6Z7NrqT4On+jqRC+ejwdxV2c46
XdyM/8ANypIP3GtNoMW/BTcW/PFjSXKNHmy80mKpSqUxuvSGEMdPyXPmCVr9341X
HNlH1wgyYzwcI1jxLYmXxch4xK54OaGoF3LZzdIaNjnoF1KgJXOi9ALMYghUKQkt
OwtIg4sBEkEpKhGB+HKernQBxkTHMvqEwon90yrXynp/Y1c4XnS4TQAEIOAfnnjq
OwX+49ELlCvjz78r9C7g0UCpeOYJ/TvWkBRhNonfRG/HjAYr+lVYERNjldZ5YI8d
gjh73FjRDPrj4VNfivreXAmuj3Zdym9PBGcsxP+SjAf3RVTf7xBfdD13Ew2NrtGH
3SbJmDA13NfMkowt62av2Pnnp5jdZX5U7GYaT6M/PO0aSB6Bzp+L0nhi5PX0KbOk
/7CRa1SFm5hnIsVC7zqS
=jFs7
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_15_35_47_+1000_Q5il6qlTH2XQdyBJ--
