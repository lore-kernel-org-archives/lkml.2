Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab2ACEr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 23:47:26 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:44611 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2ACErZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 23:47:25 -0500
Date: Tue, 3 Jan 2012 15:47:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: manual merge of the gpio tree with the devicetree tree
Message-Id: <20120103154717.da9468b24d9665b593054c10@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_15_47_17_+1100_NvHLr9c_ysSZikO/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_15_47_17_+1100_NvHLr9c_ysSZikO/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
include/linux/of.h between commit 3ecdd0515287 ("dt: add empty
of_get_node/of_put_node functions") from the devicetree tree and commit
15c9a0acc3f7 ("of: create of_phandle_args to simplify return of phandle
parsing data") from the gpio tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/of.h
index 9abd3ec,ea44fd7..0000000
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@@ -65,20 -65,13 +65,27 @@@ struct device_node=20
  #endif
  };
 =20
+ #define MAX_PHANDLE_ARGS 8
+ struct of_phandle_args {
+ 	struct device_node *np;
+ 	int args_count;
+ 	uint32_t args[MAX_PHANDLE_ARGS];
+ };
+=20
 +#if defined(CONFIG_SPARC) || !defined(CONFIG_OF)
 +/* Dummy ref counting routines - to be implemented later */
 +static inline struct device_node *of_node_get(struct device_node *node)
 +{
 +	return node;
 +}
 +static inline void of_node_put(struct device_node *node)
 +{
 +}
 +#else
 +extern struct device_node *of_node_get(struct device_node *node);
 +extern void of_node_put(struct device_node *node);
 +#endif
 +
  #ifdef CONFIG_OF
 =20
  /* Pointer for first entry in chain of all nodes. */

--Signature=_Tue__3_Jan_2012_15_47_17_+1100_NvHLr9c_ysSZikO/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAohVAAoJEECxmPOUX5FECKcQAJn8e/DVVSd+rpZ15Zf4wpr2
4HV0B6OgSLnsJaWMgvEO7lZYUDE4UWJgRFQMonC53NOKBiEPlsiXt3uJ9JGU5nJM
azrWBodRimfa5Y7nClTg/cATE6ArsAs4/GVQPPyC0RBY1OaSjK/b64fI0cjWcuj1
rhqH13hOpKntiEHkQuktGQsIIX5OWDdJ5I6JsM2F2iyg32an6zeyeF2Z/bHlxvFl
tFQklJEf6kvvLAErMtlZAF9PxGxqp4G5i+1DAHbxzp5hJaApbWUMW5/NRQGi3COE
s1X+t6tZIf3V7fvdooriVDAGmCqlqM2KcTyA5gWPd4baQRWkHv/fuUNAHwEztvI4
OfOJa/GVIraFTvmGjMTlcAzroy4qekY3pY5C1JHsMP+jRf2E/RIEc+b0GRDMEuTn
l/R3S0Ei44iTWeZaNPdzGs0SJv1dLWWBrzc9qr9p0ErU2q4oWeFdVHDia569dKk9
YX3m/GBxtZWPqVSPZh4pJopSjEgVJoP07DwdeDmVAqf2mKGbW0BpzG8DWGeuUb27
i24mPLSNRxsHtnJUbT+DlGtemspvy8weTrQxSyS9//Zy9xtluVX2aclSD26HZhG7
Jz6l7Cad3b9/zDUAFzrZA9hxzODWdCwccKuJaGMnnopqZT5GmeY/TY74Vrtw5cBd
dkCF91gqvuj1WH0MdPmN
=EBtd
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_15_47_17_+1100_NvHLr9c_ysSZikO/--
