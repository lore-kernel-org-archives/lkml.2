Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1K2BBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 20:01:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45734 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1K2BBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 20:01:11 -0500
Date: Tue, 29 Nov 2011 12:00:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: linux-next: build failure after merge of the hid tree
Message-Id: <20111129120059.a1818d7eaf663546edc6dc34@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Nov_2011_12_00_59_+1100_ydKj00YmSWqYfFce"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Nov_2011_12_00_59_+1100_ydKj00YmSWqYfFce
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

After merging the hid tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/hid/hid-input.c: In function 'hidinput_hid_event':
drivers/hid/hid-input.c:865:6: error: 'struct hid_device' has no member nam=
ed 'battery_val'
drivers/hid/hid-input.c:866:3: error: 'struct hid_device' has no member nam=
ed 'battery_min'
drivers/hid/hid-input.c:866:3: error: 'struct hid_device' has no member nam=
ed 'battery_max'

Caused by commit 4f5ca836bef3 ("HID: hid-input: add support for HID
devices reporting Battery Strength").  Those members are only defined when
CONFIG_HID_BATTERY_STRENGTH is set.

I have used the hid tree from next-20111128 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Nov_2011_12_00_59_+1100_ydKj00YmSWqYfFce
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1C7LAAoJEECxmPOUX5FEyKQP/01V8OBsu+lRNfwkuE5ZXaym
gBQ3dUW5ZXMyyTkI01qgIfa8cAAC3TSn9Sf1zL3n9TPcsPZ0G5GzNWZ0kyA00WY8
g/72RK8KFO/wPTnE3GnwIyHbwfA2LAnrEkupw/z2mgI6EGn48r4oR/hLl4cvmVEE
+uD3dFdRXnQknPjpUxkxXxC0c/+drUU0X4Q/0Jw91XoNP3UDDizB5WxrCSmz1MEu
DNNB3NZuqXdFUOEgoKdbp4CIZuy2hO1HOqDN6hw2VtrQoSFrQbvEiqy3Oqo0FJfV
5gzZUj2YynU/uFxQgHKeo0dbU4vkwhWweAIYST3+Doj0ldKrjBBrPmbTXwbTYEKf
ARsF4rD084UGpkzTl1K2NrwzOg4bRNbs1sKaY6EddENPhIqbc5goP0SqYjYV5O1y
U6ouyuXvD0x0u60tBy5UpkmWkRlThJCQ9ebBbvlR4DD5GQmxBQ6UKdRhckwPiBB+
9n0A+aibrqtma7YVQYpne8H80yxI+y8qXOF/9pMFFiEb+ZEfeHuqj25SgP/PErbf
+t4knZiECKF02Ocgh2Kq6UtVC7I+EKnV/JG+8P16y+oopg7UT0P7Ndn23SGq5t7W
G9FmwRXYqlbww6E17vqZTx8YibyeTsJg6j1W/QXlyjO9ZLbIF+qxBhMN9xu4/ggm
jCVQ/XWWfMwtALbAFO8K
=fASJ
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Nov_2011_12_00_59_+1100_ydKj00YmSWqYfFce--
