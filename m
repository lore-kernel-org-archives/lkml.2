Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2I2Q3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 12:29:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37989 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756599Ab2I2Q3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 12:29:32 -0400
Message-ID: <1348936155.18878.29.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 174/218] Bluetooth: Fix use-after-free bug in SMP
From: Ben Hutchings <ben@decadent.org.uk>
To: Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Andre Guedes <andre.guedes@openbossa.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 29 Sep 2012 18:29:15 +0200
In-Reply-To: <20120928201521.472829867@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
	 <20120928201521.472829867@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ujl2vyguSQ5Nk2Ku6CGd"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ujl2vyguSQ5Nk2Ku6CGd
Content-Type: multipart/mixed; boundary="=-Gfr+2feU0bouctG8JI09"


--=-Gfr+2feU0bouctG8JI09
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 13:16 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Andre Guedes <andre.guedes@openbossa.org>
>=20
> commit 61a0cfb008f57ecf7eb28ee762952fb42dc15d15 upstream.
>=20
> If SMP fails, we should always cancel security_timer delayed work.
> Otherwise, security_timer function may run after l2cap_conn object
> has been freed.
[...]

This particular bug doesn't appear to exist in earlier kernel versions,
but it led me to find some related bugs in teardown that do.

I'm attaching two patches:
- bluetooth-fix-l2cap_conn_del-locking.patch seems to be needed for both
  3.0 and 3.2.  It's very different from the upstream changes, and is
  compile-tested only.
- bluetooth-fix-deadlock-and-crash-when-smp-pairing-times-out.patch
  (commit d06cc416f517a25713dedd9e2a9ccf4f3086c09a upstream) seems to be
  needed for 3.2 only.

What do you think?

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-Gfr+2feU0bouctG8JI09
Content-Disposition: attachment; filename="bluetooth-fix-l2cap_conn_del-locking.patch"
Content-Type: text/x-patch; name="bluetooth-fix-l2cap_conn_del-locking.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbTogQmVuIEh1dGNoaW5ncyA8YmVuQGRlY2FkZW50Lm9yZy51az4NCkRhdGU6IFNhdCwgMjkg
U2VwIDIwMTIgMTc6NTM6MjggKzAyMDANClN1YmplY3Q6IEJsdWV0b290aDogRml4IGwyY2FwX2Nv
bm5fZGVsKCkgbG9ja2luZw0KDQpUaGlzIGlzIGNvdmVyZWQgYnkgY29tbWl0IDNkZjkxZWEyMGU3
NDQzNDQxMDBiMTBhZTY5YTE3MjExZmNmNWIyMDcNCignQmx1ZXRvb3RoOiBSZXZlcnQgdG8gbXV0
ZXhlcyBmcm9tIFJDVSBsaXN0JykgdXBzdHJlYW0uDQoNCmwyY2FwX2Nvbm5fZGVsKCkgY2FuIHJh
Y2Ugd2l0aCB2YXJpb3VzIG90aGVyIGZ1bmN0aW9ucyB0aGF0IHdhbGsgdGhlDQpjaGFubmVsIGxp
c3Q7IGluIHBhcnRpY3VsYXIgbDJjYXBfY29ubl9zdGFydCgpIHdoaWNoIGlzIGNhbGxlZCBmcm9t
DQpsMmNhcF9pbmZvX3RpbWVvdXQoKS4gIGwyY2FwX2NoYW5fZGVsKCkgaXRzZWxmIHRha2VzIHRo
ZSBjaGFuX2xvY2sgZm9yDQp3cml0aW5nLCBzbyBpbnN0ZWFkIG9mIGxvY2tpbmcgaGVyZSB3ZSBt
dXN0IG1vdmUgYWxsIGNoYW5uZWxzIG9udG8gYQ0KdGVtcG9yYXJ5IGxpc3QuDQoNClNpZ25lZC1v
ZmYtYnk6IEJlbiBIdXRjaGluZ3MgPGJlbkBkZWNhZGVudC5vcmcudWs+DQotLS0NCi0tLSBhL25l
dC9ibHVldG9vdGgvbDJjYXBfY29yZS5jDQorKysgYi9uZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUu
Yw0KQEAgLTk2OCw2ICs5NjgsNyBAQCBzdGF0aWMgdm9pZCBsMmNhcF9pbmZvX3RpbWVvdXQodW5z
aWduZWQNCiBzdGF0aWMgdm9pZCBsMmNhcF9jb25uX2RlbChzdHJ1Y3QgaGNpX2Nvbm4gKmhjb24s
IGludCBlcnIpDQogew0KIAlzdHJ1Y3QgbDJjYXBfY29ubiAqY29ubiA9IGhjb24tPmwyY2FwX2Rh
dGE7DQorCXN0cnVjdCBsaXN0X2hlYWQgY2hhbl9sOw0KIAlzdHJ1Y3QgbDJjYXBfY2hhbiAqY2hh
biwgKmw7DQogCXN0cnVjdCBzb2NrICpzazsNCiANCkBAIC05NzgsOCArOTc5LDEzIEBAIHN0YXRp
YyB2b2lkIGwyY2FwX2Nvbm5fZGVsKHN0cnVjdCBoY2lfY28NCiANCiAJa2ZyZWVfc2tiKGNvbm4t
PnJ4X3NrYik7DQogDQorCUlOSVRfTElTVF9IRUFEKCZjaGFuX2wpOw0KKwl3cml0ZV9sb2NrX2Jo
KCZjb25uLT5jaGFuX2xvY2spOw0KKwlsaXN0X3NwbGljZV9pbml0KCZjb25uLT5jaGFuX2wsICZj
aGFuX2wpOw0KKwl3cml0ZV91bmxvY2tfYmgoJmNvbm4tPmNoYW5fbG9jayk7DQorDQogCS8qIEtp
bGwgY2hhbm5lbHMgKi8NCi0JbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGNoYW4sIGwsICZjb25u
LT5jaGFuX2wsIGxpc3QpIHsNCisJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGNoYW4sIGwsICZj
aGFuX2wsIGxpc3QpIHsNCiAJCXNrID0gY2hhbi0+c2s7DQogCQliaF9sb2NrX3NvY2soc2spOw0K
IAkJbDJjYXBfY2hhbl9kZWwoY2hhbiwgZXJyKTsNCg==


--=-Gfr+2feU0bouctG8JI09
Content-Disposition: attachment;
	filename*0=bluetooth-fix-deadlock-and-crash-when-smp-pairing-times-out.p;
	filename*1=atch
Content-Type: text/x-patch;
	name="bluetooth-fix-deadlock-and-crash-when-smp-pairing-times-out.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbTogSm9oYW4gSGVkYmVyZyA8am9oYW4uaGVkYmVyZ0BpbnRlbC5jb20+DQpEYXRlOiBXZWQs
IDYgSnVuIDIwMTIgMTg6NDQ6MTEgKzA4MDANClN1YmplY3Q6IEJsdWV0b290aDogRml4IGRlYWRs
b2NrIGFuZCBjcmFzaCB3aGVuIFNNUCBwYWlyaW5nIHRpbWVzIG91dA0KDQpjb21taXQgZDA2Y2M0
MTZmNTE3YTI1NzEzZGVkZDllMmE5Y2NmNGYzMDg2YzA5YSB1cHN0cmVhbS4NCg0KVGhlIGwyY2Fw
X2Nvbm5fZGVsIGZ1bmN0aW9uIHRyaWVzIHRvIGNhbmNlbF9zeW5jIHRoZSBzZWN1cml0eSB0aW1l
ciwgYnV0DQp3aGVuIGl0J3MgY2FsbGVkIGZyb20gdGhlIHRpbWVvdXQgZnVuY3Rpb24gaXRzZWxm
IGEgZGVhZGxvY2sgb2NjdXJzLg0KU3Vic2VxdWVudGx5IHRoZSAiaGNvbi0+bDJjYXBfZGF0YSA9
IE5VTEwiIHRoYXQncyBzdXBwb3NlZCB0byBwcm90ZWN0DQptdWx0aXBsZSBjYWxscyB0byBsMmNh
cF9jb25uX2RlbCBuZXZlciBnZXRzIGNsZWFyZWQgYW5kIHdoZW4gdGhlDQpjb25uZWN0aW9uIGZp
bmFsbHkgZHJvcHMgd2UgZG91YmxlIGZyZWUncyBldGMgd2hpY2ggd2lsbCBjcmFzaCB0aGUNCmtl
cm5lbC4NCg0KVGhpcyBwYXRjaCBmaXhlcyB0aGUgaXNzdWUgYnkgdXNpbmcgdGhlIEhDSV9DT05O
X0xFX1NNUF9QRU5EIGZvcg0KcHJvdGVjdGluZyBhZ2FpbnN0IHRoaXMuIFRoZSBzYW1lIGZsYWcg
aXMgYWxzbyB1c2VkIGZvciB0aGUgc2FtZSBwdXJwb3NlDQppbiBvdGhlciBwbGFjZXMgaW4gdGhl
IFNNUCBjb2RlLg0KDQpTaWduZWQtb2ZmLWJ5OiBKb2hhbiBIZWRiZXJnIDxqb2hhbi5oZWRiZXJn
QGludGVsLmNvbT4NClNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gUGFkb3ZhbiA8Z3VzdGF2by5wYWRv
dmFuQGNvbGxhYm9yYS5jby51az4NCltid2g6IEJhY2twb3J0ZWQgdG8gMy4yOiBwZW5kaW5nIGZs
YWdzIGFyZSBpbiBoY2lfY29ubjo6cGVuZF0NClNpZ25lZC1vZmYtYnk6IEJlbiBIdXRjaGluZ3Mg
PGJlbkBkZWNhZGVudC5vcmcudWs+DQotLS0NCiBuZXQvYmx1ZXRvb3RoL2wyY2FwX2NvcmUuYyB8
ICAgIDcgKysrKysrLQ0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCg0KLS0tIGEvbmV0L2JsdWV0b290aC9sMmNhcF9jb3JlLmMNCisrKyBiL25ldC9ibHVl
dG9vdGgvbDJjYXBfY29yZS5jDQpAQCAtMTAwOSw3ICsxMDA5LDEyIEBAIHN0YXRpYyB2b2lkIHNl
Y3VyaXR5X3RpbWVvdXQodW5zaWduZWQgbG8NCiB7DQogCXN0cnVjdCBsMmNhcF9jb25uICpjb25u
ID0gKHZvaWQgKikgYXJnOw0KIA0KLQlsMmNhcF9jb25uX2RlbChjb25uLT5oY29uLCBFVElNRURP
VVQpOw0KKwlCVF9EQkcoImNvbm4gJXAiLCBjb25uKTsNCisNCisJaWYgKHRlc3RfYW5kX2NsZWFy
X2JpdChIQ0lfQ09OTl9MRV9TTVBfUEVORCwgJmNvbm4tPmhjb24tPnBlbmQpKSB7DQorCQlzbXBf
Y2hhbl9kZXN0cm95KGNvbm4pOw0KKwkJbDJjYXBfY29ubl9kZWwoY29ubi0+aGNvbiwgRVRJTUVE
T1VUKTsNCisJfQ0KIH0NCiANCiBzdGF0aWMgc3RydWN0IGwyY2FwX2Nvbm4gKmwyY2FwX2Nvbm5f
YWRkKHN0cnVjdCBoY2lfY29ubiAqaGNvbiwgdTggc3RhdHVzKQ0K


--=-Gfr+2feU0bouctG8JI09--

--=-Ujl2vyguSQ5Nk2Ku6CGd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGch2+e/yOyVhhEJAQprThAApVD9t9ZoWxttsFN5jgzS/ji5qX+MtlMi
nV9PsEpFgwGShO2TnapBxvrmCNLHtCKNmiBWHkueFWzFSvZSKt7t11R7hlk1dwBm
b4KmvSSWbilZWe3OcUJBpI0nmU0mm2A4FtpeAAieWRw/0YQD7uoWl8k9qMigNohh
CtDMNXUrXqtFjXIPgyzKiw/TKl6q7fROPlwol6ORDy8tOjkTy/IVAYwLrbMxIDDo
4S2h6Jscdw7iFbXyZxcLUnV6A02+IlkLtH1v7YWkqWTBbZShrn+tRayUtNi2qDQx
4pg1IhTJaxc6mp6spIaTRaHm0wrEZIlyzPcwujSlaQlN8JvERdUQqYpbnSopBQPz
1LdBDQ9mMbrT4r1sQBNwRuvrL2n3ZWD/KWsQZUyPa/xws9QCFhi2X/T7LADu7UKn
L/VCgB08SoQPOU2ue16QWHxMgvF1cRi7CSsOUX8DWuG+tqYgeDKjnUiaCvGjQDGx
ObfCvKtfirYXq1YPsNnAzMzezjB2tr0ghR5O106uM1GB6ZSII3Ax/0D1ez6ITsHw
iXjvQjrQXMwzJ2wZ95OtQ0YuV6e2I4NpMqqfUggiYSvtPHzaquUR/whYrywAeSSi
F77CLLheYu4mz+7cuCzmvqCQ+V8fbYKyQ/D+OtfWsrCh8MilSv9kBOuCEOhxg504
RaJuGO4ax10=
=sSlo
-----END PGP SIGNATURE-----

--=-Ujl2vyguSQ5Nk2Ku6CGd--
