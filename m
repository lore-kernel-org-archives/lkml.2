Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2DNFXo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 01:23:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53095 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab2DNFXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 01:23:43 -0400
Message-ID: <1334381003.7150.409.camel@deadeye>
Subject: Re: [ 42/78] PM / Runtime: dont forget to wake up waitqueue on
 failure
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sat, 14 Apr 2012 06:23:23 +0100
In-Reply-To: <20120411231025.387614571@linuxfoundation.org>
References: <20120411231025.387614571@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RkU4a8K/QqT8N+gkkwM5"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RkU4a8K/QqT8N+gkkwM5
Content-Type: multipart/mixed; boundary="=-2vsDEyH50VnF/gJIb0f/"


--=-2vsDEyH50VnF/gJIb0f/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-04-11 at 16:11 -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Alan Stern <stern@rowland.harvard.edu>
>=20
> commit f2791d733a2f06997b573d1a3cfde21e6f529826 upstream.
>=20
> This patch (as1535) fixes a bug in the runtime PM core.  When a
> runtime suspend attempt completes, whether successfully or not, the
> device's power.wait_queue is supposed to be signalled.  But this
> doesn't happen in the failure pathway of rpm_suspend() when another
> autosuspend attempt is rescheduled.  As a result, a task can get stuck
> indefinitely on the wait queue (I have seen this happen in testing).
>=20
> The patch fixes the problem by moving the wake_up_all() call up near
> the start of the failure code.
[...]

It looks like this is also relevant to 3.2, but the code got moved
around a bit between 3.2 and 3.3.  Attaching my (untested) backport.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-2vsDEyH50VnF/gJIb0f/
Content-Disposition: attachment;
	filename*0=0001-PM-Runtime-don-t-forget-to-wake-up-waitqueue-on-fail.pat;
	filename*1=ch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0001-PM-Runtime-don-t-forget-to-wake-up-waitqueue-on-fail.patch";
	charset="UTF-8"

RnJvbSAzODUzZWVlM2E3YWFlMmVkYTFiYjhmOWYwYzliODIyNmNiYmE0YmZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogQWxhbiBTdGVybiA8c3Rlcm5Acm93bGFuZC5oYXJ2YXJkLmVk
dT4NCkRhdGU6IE1vbiwgMjYgTWFyIDIwMTIgMjI6NDY6NTIgKzAyMDANClN1YmplY3Q6IFtQQVRD
SF0gUE0gLyBSdW50aW1lOiBkb24ndCBmb3JnZXQgdG8gd2FrZSB1cCB3YWl0cXVldWUgb24gZmFp
bHVyZQ0KDQpjb21taXQgZjI3OTFkNzMzYTJmMDY5OTdiNTczZDFhM2NmZGUyMWU2ZjUyOTgyNiB1
cHN0cmVhbS4NCg0KVGhpcyBwYXRjaCAoYXMxNTM1KSBmaXhlcyBhIGJ1ZyBpbiB0aGUgcnVudGlt
ZSBQTSBjb3JlLiAgV2hlbiBhDQpydW50aW1lIHN1c3BlbmQgYXR0ZW1wdCBjb21wbGV0ZXMsIHdo
ZXRoZXIgc3VjY2Vzc2Z1bGx5IG9yIG5vdCwgdGhlDQpkZXZpY2UncyBwb3dlci53YWl0X3F1ZXVl
IGlzIHN1cHBvc2VkIHRvIGJlIHNpZ25hbGxlZC4gIEJ1dCB0aGlzDQpkb2Vzbid0IGhhcHBlbiBp
biB0aGUgZmFpbHVyZSBwYXRod2F5IG9mIHJwbV9zdXNwZW5kKCkgd2hlbiBhbm90aGVyDQphdXRv
c3VzcGVuZCBhdHRlbXB0IGlzIHJlc2NoZWR1bGVkLiAgQXMgYSByZXN1bHQsIGEgdGFzayBjYW4g
Z2V0IHN0dWNrDQppbmRlZmluaXRlbHkgb24gdGhlIHdhaXQgcXVldWUgKEkgaGF2ZSBzZWVuIHRo
aXMgaGFwcGVuIGluIHRlc3RpbmcpLg0KDQpUaGUgcGF0Y2ggZml4ZXMgdGhlIHByb2JsZW0gYnkg
bW92aW5nIHRoZSB3YWtlX3VwX2FsbCgpIGNhbGwgdXAgbmVhcg0KdGhlIHN0YXJ0IG9mIHRoZSBm
YWlsdXJlIGNvZGUuDQoNClNpZ25lZC1vZmYtYnk6IEFsYW4gU3Rlcm4gPHN0ZXJuQHJvd2xhbmQu
aGFydmFyZC5lZHU+DQpTaWduZWQtb2ZmLWJ5OiBSYWZhZWwgSi4gV3lzb2NraSA8cmp3QHNpc2su
cGw+DQpbYndoOiBCYWNrcG9ydGVkIHRvIDMuMjogYWRqdXN0IGNvbnRleHQgYW5kIGluZGVudGF0
aW9uXQ0KU2lnbmVkLW9mZi1ieTogQmVuIEh1dGNoaW5ncyA8YmVuQGRlY2FkZW50Lm9yZy51az4N
Ci0tLQ0KIGRyaXZlcnMvYmFzZS9wb3dlci9ydW50aW1lLmMgfCAgICAzICsrLQ0KIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvYmFzZS9wb3dlci9ydW50aW1lLmMgYi9kcml2ZXJzL2Jhc2UvcG93ZXIvcnVudGltZS5j
DQppbmRleCA4Yzc4NDQzLi4yNDI0YmU1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9iYXNlL3Bvd2Vy
L3J1bnRpbWUuYw0KKysrIGIvZHJpdmVycy9iYXNlL3Bvd2VyL3J1bnRpbWUuYw0KQEAgLTQxNyw2
ICs0MTcsOCBAQCBzdGF0aWMgaW50IHJwbV9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldiwgaW50
IHJwbWZsYWdzKQ0KIAlpZiAocmV0dmFsKSB7DQogCQlfX3VwZGF0ZV9ydW50aW1lX3N0YXR1cyhk
ZXYsIFJQTV9BQ1RJVkUpOw0KIAkJZGV2LT5wb3dlci5kZWZlcnJlZF9yZXN1bWUgPSBmYWxzZTsN
CisJCXdha2VfdXBfYWxsKCZkZXYtPnBvd2VyLndhaXRfcXVldWUpOw0KKw0KIAkJaWYgKHJldHZh
bCA9PSAtRUFHQUlOIHx8IHJldHZhbCA9PSAtRUJVU1kpIHsNCiAJCQlkZXYtPnBvd2VyLnJ1bnRp
bWVfZXJyb3IgPSAwOw0KIA0KQEAgLTQzMiw3ICs0MzQsNiBAQCBzdGF0aWMgaW50IHJwbV9zdXNw
ZW5kKHN0cnVjdCBkZXZpY2UgKmRldiwgaW50IHJwbWZsYWdzKQ0KIAkJfSBlbHNlIHsNCiAJCQlw
bV9ydW50aW1lX2NhbmNlbF9wZW5kaW5nKGRldik7DQogCQl9DQotCQl3YWtlX3VwX2FsbCgmZGV2
LT5wb3dlci53YWl0X3F1ZXVlKTsNCiAJCWdvdG8gb3V0Ow0KIAl9DQogIG5vX2NhbGxiYWNrOg0K
LS0gDQoxLjcuOS41DQoNCg==


--=-2vsDEyH50VnF/gJIb0f/--

--=-RkU4a8K/QqT8N+gkkwM5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT4kJy+e/yOyVhhEJAQrMkQ/6AxcTnpQuySBsUTajuFairtM8IvwbzNoc
hwkZt27pKjo04KmvBtOAZY0jc+KbWFiF73d6d8ePDSZqa0BLa8ocfZDEbFdup8ER
vSkyGAGjDz4LtZ8pzc0QrM6yBfcXYotXs9kkx9qwRUUIUPX3YviPmCSh3Nz04C6U
IyamcoGTn0OlHXT7hRTJokPC9ggrvJ8Yi3YuBgpboQmD8RsS0yp5iJb4YVqX+H0Y
Hja5Jhjwz9ZIlvm+soa49io4xGSaQrYB1NrHsujjGLF42fdKClSGUrb+Bfppe9KV
xL9CvaDsyWcejA0/A3e0m5aWColg3xLx696hAqS0DYNXTHEo6AiDyIeOgwPta+FI
Sd7aCntS+QxLR3OdkHzbBXh59DUQZpjWeJnSXk1nZelwWKqFVcTHlS+HEvbmPRXC
mXLjFFRQvNkc8LqTtsuvOda/T5TNsutM9aKgU/tC4+PgX2v922JzpSnC5JMxgkS/
dq/vWhGMza/nye3EJ6WgcDpDDb81g/OT8FgXj6Ibb8rWciXnpOui8TG1pSFrw7Nb
9L8jLsnJBwHaLC+fuI4yjQbABntc4mw0lFpsxnccUx0I6z97OhRm9SZ67W0y9ZMi
Pr8LHOYsI+x02u/IxII8pVPfQrc3FkBqDvKXkKXxgt4iZ7C9uJNgIFQao25hKHtm
kaBaRQnEibs=
=gwYo
-----END PGP SIGNATURE-----

--=-RkU4a8K/QqT8N+gkkwM5--
