Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab2DNFg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 01:36:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302Ab2DNFg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 01:36:26 -0400
Message-ID: <1334381772.7150.412.camel@deadeye>
Subject: Re: [ 31/78] ath9k: fix max noise floor threshold
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>,
        Madhan Jaganathan <madhanj@qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Stewart <pstew@google.com>,
        Gary Morain <gmorain@google.com>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 14 Apr 2012 06:36:12 +0100
In-Reply-To: <20120411231023.489450259@linuxfoundation.org>
References: <20120411231023.489450259@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3lHNjccGnooJDgdubsJD"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3lHNjccGnooJDgdubsJD
Content-Type: multipart/mixed; boundary="=-VmLgdJ+5/A/aHeSrCJXb"


--=-VmLgdJ+5/A/aHeSrCJXb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-04-11 at 16:10 -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
>=20
> commit 2ee0a07028d2cde6e131b73f029dae2b93c50f3a upstream.
>=20
> Currently the maximum noise floor limit is set as too high (-60dB). The
> assumption of having a higher threshold limit is that it would help
> de-sensitize the receiver (reduce phy errors) from continuous
> interference. But when we have a bursty interference where there are
> collisions and then free air time and if the receiver is desensitized too
> much, it will miss the normal packets too. Lets make use of chips
> specific min, nom and max limits always. This patch helps to improve the
> connection stability in congested networks.
[...]

It looks like this is also applicable to 3.0 and 3.2, but the debug
logging statement changed between 3.2 and 3.3 and stopped this from
applying directly.  Attaching an (untested) backport.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-VmLgdJ+5/A/aHeSrCJXb
Content-Disposition: attachment; filename="0001-ath9k-fix-max-noise-floor-threshold.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-ath9k-fix-max-noise-floor-threshold.patch";
	charset="UTF-8"

RnJvbSA2ZDE5Y2I3YjMzMjVlNmM0NjBkYjBmMDdmMTc4NzkzZjQ1MDA3ODNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogUmFqa3VtYXIgTWFub2hhcmFuIDxybWFub2hhckBxY2EucXVh
bGNvbW0uY29tPg0KRGF0ZTogVGh1LCAxNSBNYXIgMjAxMiAwNjowODowNCArMDUzMA0KU3ViamVj
dDogW1BBVENIXSBhdGg5azogZml4IG1heCBub2lzZSBmbG9vciB0aHJlc2hvbGQNCg0KY29tbWl0
IDJlZTBhMDcwMjhkMmNkZTZlMTMxYjczZjAyOWRhZTJiOTNjNTBmM2EgdXBzdHJlYW0uDQoNCkN1
cnJlbnRseSB0aGUgbWF4aW11bSBub2lzZSBmbG9vciBsaW1pdCBpcyBzZXQgYXMgdG9vIGhpZ2gg
KC02MGRCKS4gVGhlDQphc3N1bXB0aW9uIG9mIGhhdmluZyBhIGhpZ2hlciB0aHJlc2hvbGQgbGlt
aXQgaXMgdGhhdCBpdCB3b3VsZCBoZWxwDQpkZS1zZW5zaXRpemUgdGhlIHJlY2VpdmVyIChyZWR1
Y2UgcGh5IGVycm9ycykgZnJvbSBjb250aW51b3VzDQppbnRlcmZlcmVuY2UuIEJ1dCB3aGVuIHdl
IGhhdmUgYSBidXJzdHkgaW50ZXJmZXJlbmNlIHdoZXJlIHRoZXJlIGFyZQ0KY29sbGlzaW9ucyBh
bmQgdGhlbiBmcmVlIGFpciB0aW1lIGFuZCBpZiB0aGUgcmVjZWl2ZXIgaXMgZGVzZW5zaXRpemVk
IHRvbw0KbXVjaCwgaXQgd2lsbCBtaXNzIHRoZSBub3JtYWwgcGFja2V0cyB0b28uIExldHMgbWFr
ZSB1c2Ugb2YgY2hpcHMNCnNwZWNpZmljIG1pbiwgbm9tIGFuZCBtYXggbGltaXRzIGFsd2F5cy4g
VGhpcyBwYXRjaCBoZWxwcyB0byBpbXByb3ZlIHRoZQ0KY29ubmVjdGlvbiBzdGFiaWxpdHkgaW4g
Y29uZ2VzdGVkIG5ldHdvcmtzLg0KDQpDYzogUGF1bCBTdGV3YXJ0IDxwc3Rld0Bnb29nbGUuY29t
Pg0KVGVzdGVkLWJ5OiBHYXJ5IE1vcmFpbiA8Z21vcmFpbkBnb29nbGUuY29tPg0KU2lnbmVkLW9m
Zi1ieTogTWFkaGFuIEphZ2FuYXRoYW4gPG1hZGhhbmpAcWNhLnF1YWxjb21tLmNvbT4NClNpZ25l
ZC1vZmYtYnk6IFJhamt1bWFyIE1hbm9oYXJhbiA8cm1hbm9oYXJAcWNhLnF1YWxjb21tLmNvbT4N
ClNpZ25lZC1vZmYtYnk6IEpvaG4gVy4gTGludmlsbGUgPGxpbnZpbGxlQHR1eGRyaXZlci5jb20+
DQpbYndoOiBCYWNrcG9ydGVkIHRvIDMuMC8zLjI6IGFkanVzdCBjb250ZXh0XQ0KU2lnbmVkLW9m
Zi1ieTogQmVuIEh1dGNoaW5ncyA8YmVuQGRlY2FkZW50Lm9yZy51az4NCi0tLQ0KIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9jYWxpYi5jIHwgICAgNSArKy0tLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsvY2FsaWIuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9jYWxpYi5jDQppbmRleCA4ZGRlZjNlLi5kNzcxZGU1IDEwMDY0NA0KLS0tIGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2NhbGliLmMNCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGg5ay9jYWxpYi5jDQpAQCAtMjAsNyArMjAsNiBAQA0KIA0KIC8qIENv
bW1vbiBjYWxpYnJhdGlvbiBjb2RlICovDQogDQotI2RlZmluZSBBVEg5S19ORl9UT09fSElHSAkt
NjANCiANCiBzdGF0aWMgaW50MTZfdCBhdGg5a19od19nZXRfbmZfaGlzdF9taWQoaW50MTZfdCAq
bmZDYWxCdWZmZXIpDQogew0KQEAgLTM0OCwxMCArMzQ3LDEwIEBAIHN0YXRpYyB2b2lkIGF0aDlr
X2h3X25mX3Nhbml0aXplKHN0cnVjdCBhdGhfaHcgKmFoLCBzMTYgKm5mKQ0KIAkJCSJORiBjYWxp
YnJhdGVkIFslc10gW2NoYWluICVkXSBpcyAlZFxuIiwNCiAJCQkoaSA+PSAzID8gImV4dCIgOiAi
Y3RsIiksIGkgJSAzLCBuZltpXSk7DQogDQotCQlpZiAobmZbaV0gPiBBVEg5S19ORl9UT09fSElH
SCkgew0KKwkJaWYgKG5mW2ldID4gbGltaXQtPm1heCkgew0KIAkJCWF0aF9kYmcoY29tbW9uLCBB
VEhfREJHX0NBTElCUkFURSwNCiAJCQkJIk5GWyVkXSAoJWQpID4gTUFYICglZCksIGNvcnJlY3Rp
bmcgdG8gTUFYXG4iLA0KLQkJCQlpLCBuZltpXSwgQVRIOUtfTkZfVE9PX0hJR0gpOw0KKwkJCQlp
LCBuZltpXSwgbGltaXQtPm1heCk7DQogCQkJbmZbaV0gPSBsaW1pdC0+bWF4Ow0KIAkJfSBlbHNl
IGlmIChuZltpXSA8IGxpbWl0LT5taW4pIHsNCiAJCQlhdGhfZGJnKGNvbW1vbiwgQVRIX0RCR19D
QUxJQlJBVEUsDQotLSANCjEuNy45LjUNCg0K


--=-VmLgdJ+5/A/aHeSrCJXb--

--=-3lHNjccGnooJDgdubsJD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4kMzOe/yOyVhhEJAQo/Qg/8DHiiGSYIQpWRYr1vclkY6c0UmgsdtOup
UIgT8YFRWVlMQV285Te+7wozn3EY3YRGwqWbI/sIPF1VwjQKXndHKFCMAFpDDcB+
ZV8uzgSZXZ1Lgvaf3O8pVqtlOqx24ny2CXDcLajG2phYVCMQfnc25RX4mAIDhWIq
gMxh9R4qBmLw/OlKeQPlEbsl8MmDLtGbL7d+/Axm1fMxqHl05B8KLO+CVBFOgUk0
H+YMO7BVkegcg6JfcfI/lZuNkkyYViDae7A0Xk27faChUL3DV+uleXAXmvbKNasX
LkzE9K5sp8moy/JUODb6+OYG+GRoeiI+ygsDjlDwDJqOxrZNAP6CcW/L5dW82g88
7T3NmzN8PGwUr4A6K9JkMngeuF6Py7c/nDJGu/60PxUlh+znfIKioL5Bl/+l87ET
6HnPBvY8ulHBkjlTc9ScX6ke7WuTti+uDJvlEFrtpzaxjIO6dAxDY8zwuRd1Ufwy
o6MOORtWh1NYt+5IPXRwKQwMg/agW57t+7EjN+iOsXVyv1gHahomtluirAUAdYLZ
14+hs7BOOuw8VWj2riShdtmnTxRns2GAqjCPTBjNE0jlak/a7wB3wSJRrM4AsmFO
ph7W0H26jmyrfmNk7AuONAXXvbKT1McNTecQiY0AetVN5b5jv1IY5mFJN9Vnpc6c
ogLJJsYNmWw=
=xnqL
-----END PGP SIGNATURE-----

--=-3lHNjccGnooJDgdubsJD--
