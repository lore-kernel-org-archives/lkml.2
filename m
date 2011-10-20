Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1JTCzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:55:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:22827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1JTCze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:55:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,376,1315206000"; 
   d="scan'208,223";a="79870154"
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Norbert Preining <preining@logic.at>
CC: David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 19 Oct 2011 19:55:28 -0700
Subject: RE: iwlagn is getting very shaky
Thread-Topic: iwlagn is getting very shaky
Thread-Index: AcyO0ykQl7Pt+DBaQuyVrb8VUBmn1gAAEj1A
Message-ID: <E9954878DD1FB34FAE5187FB88C58A3501A0D0992E@orsmsx506.amr.corp.intel.com>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
 <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
 <1319003304.31823.46.camel@wwguy-huron>
 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
 <1319004836.31823.57.camel@wwguy-huron>
 <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
 <1319038282.25023.21.camel@wwguy-ubuntu>
 <20111020020225.GO11060@gamma.logic.tuwien.ac.at>
 <1319074339.31823.68.camel@wwguy-huron>
 <20111020025123.GR11060@gamma.logic.tuwien.ac.at>
In-Reply-To: <20111020025123.GR11060@gamma.logic.tuwien.ac.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_E9954878DD1FB34FAE5187FB88C58A3501A0D0992Eorsmsx506amrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_E9954878DD1FB34FAE5187FB88C58A3501A0D0992Eorsmsx506amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hmm, I am sure I have the attachment, but here I attach again.

Also, the patch is simple. Only few lines

>From 78e955b90a8e259d180bfb962ef4558645d74a91 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Wed, 19 Oct 2011 18:27:41 -0700
Subject: [PATCH 1/1] iwlagn: stop queue testing

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wirel=
ess/iwlwifi/iwl-agn-lib.c
index 3bee0f1..d543686 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -191,8 +191,14 @@ static void iwlagn_set_tx_status(struct iwl_priv *priv=
,
 	if (status =3D=3D TX_STATUS_FAIL_PASSIVE_NO_RX &&
 	    iwl_is_associated_ctx(ctx) && ctx->vif &&
 	    ctx->vif->type =3D=3D NL80211_IFTYPE_STATION) {
+#if 0
 		ctx->last_tx_rejected =3D true;
 		iwl_stop_queue(priv, &priv->txq[txq_id]);
+#endif
+IWL_ERR(priv,
+       "Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (%d)\n"=
,
+       txq_id);
+
 	}
=20
 	IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x) rate_n_flags "
--=20
1.7.0.4

Thanks
Wey
-----Original Message-----
From: Norbert Preining [mailto:preining@logic.at]=20
Sent: Wednesday, October 19, 2011 7:51 PM
To: Guy, Wey-Yi W
Cc: David Rientjes; linux-kernel@vger.kernel.org; ipw3945-devel@lists.sourc=
eforge.net; ilw@linux.intel.com; linux-wireless@vger.kernel.org; Pekka Enbe=
rg
Subject: Re: iwlagn is getting very shaky

On Mi, 19 Okt 2011, Guy, Wey-Yi wrote:
> > Do you mean the patch you send with a strange date:
...

> > It does not apply at all, I cannot even find
> > 	rejected
> > in iwl-agn-tx.c.
> >=20
> > On which tree is that based, can you provide a patch against main=20
> > git branch of Linus.
> >=20
> > Thanks.
> >=20
> Let's try this and see if apply. btw, are you on 5GHz?

Which one??? Nothing attached, nothing received, and the patch you sent bef=
ore does not apply .... not even with manual intervention ... at least I am=
 not able.

5GHz: I don't know by now, not at university by now.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
`Ford, you're turning into a penguin. Stop it.'
                 --- Arthur experiences the improbability drive at work.
                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy

--_002_E9954878DD1FB34FAE5187FB88C58A3501A0D0992Eorsmsx506amrc_
Content-Type: application/octet-stream;
	name="0001-iwlagn-stop-queue-testing.patch"
Content-Description: 0001-iwlagn-stop-queue-testing.patch
Content-Disposition: attachment;
	filename="0001-iwlagn-stop-queue-testing.patch"; size=1140;
	creation-date="Wed, 19 Oct 2011 19:53:56 GMT";
	modification-date="Wed, 19 Oct 2011 19:53:56 GMT"
Content-Transfer-Encoding: base64

RnJvbSA3OGU5NTViOTBhOGUyNTlkMTgwYmZiOTYyZWY0NTU4NjQ1ZDc0YTkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogV2V5LVlpIEd1eSA8d2V5LXlpLncuZ3V5QGludGVsLmNvbT4N
CkRhdGU6IFdlZCwgMTkgT2N0IDIwMTEgMTg6Mjc6NDEgLTA3MDANClN1YmplY3Q6IFtQQVRDSCAx
LzFdIGl3bGFnbjogc3RvcCBxdWV1ZSB0ZXN0aW5nDQoNClNpZ25lZC1vZmYtYnk6IFdleS1ZaSBH
dXkgPHdleS15aS53Lmd1eUBpbnRlbC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC93aXJlbGVzcy9p
d2x3aWZpL2l3bC1hZ24tbGliLmMgfCAgICA2ICsrKysrKw0KIDEgZmlsZXMgY2hhbmdlZCwgNiBp
bnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLWxpYi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXds
d2lmaS9pd2wtYWduLWxpYi5jDQppbmRleCAzYmVlMGYxLi5kNTQzNjg2IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLWxpYi5jDQorKysgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tbGliLmMNCkBAIC0xOTEsOCArMTkxLDE0IEBA
IHN0YXRpYyB2b2lkIGl3bGFnbl9zZXRfdHhfc3RhdHVzKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwN
CiAJaWYgKHN0YXR1cyA9PSBUWF9TVEFUVVNfRkFJTF9QQVNTSVZFX05PX1JYICYmDQogCSAgICBp
d2xfaXNfYXNzb2NpYXRlZF9jdHgoY3R4KSAmJiBjdHgtPnZpZiAmJg0KIAkgICAgY3R4LT52aWYt
PnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfU1RBVElPTikgew0KKyNpZiAwDQogCQljdHgtPmxhc3Rf
dHhfcmVqZWN0ZWQgPSB0cnVlOw0KIAkJaXdsX3N0b3BfcXVldWUocHJpdiwgJnByaXYtPnR4cVt0
eHFfaWRdKTsNCisjZW5kaWYNCitJV0xfRVJSKHByaXYsDQorICAgICAgICJFbmNvdW50ZXIgVFhf
U1RBVFVTX0ZBSUxfUEFTU0lWRV9OT19SWCwgYW0gSSBvbiA1LjJHIGJhbmQ/ICglZClcbiIsDQor
ICAgICAgIHR4cV9pZCk7DQorDQogCX0NCiANCiAJSVdMX0RFQlVHX1RYX1JFUExZKHByaXYsICJU
WFEgJWQgc3RhdHVzICVzICgweCUwOHgpIHJhdGVfbl9mbGFncyAiDQotLSANCjEuNy4wLjQNCg0K

--_002_E9954878DD1FB34FAE5187FB88C58A3501A0D0992Eorsmsx506amrc_--
