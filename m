Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab0KZBPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 20:15:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45883 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752242Ab0KZBPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 20:15:42 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        stable-review@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-efgJDUh/ODBRktEGwNzA"
Date: Fri, 26 Nov 2010 01:15:30 +0000
Message-ID: <1290734130.2928.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [22/45] KVM: Fix fs/gs reload oops with
 invalid ldt
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-efgJDUh/ODBRktEGwNzA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Greg KH <gregkh@suse.de> wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.

Obviously it's a bit late now, but...

> ------------------
>=20
> From: Avi Kivity <avi@redhat.com>
>=20
> commit 9581d442b9058d3699b4be568b6e5eae38a41493 upstream
>
> kvm reloads the host's fs and gs blindly, however the underlying segment
> descriptors may be invalid due to the user modifying the ldt after loadin=
g
> them.
>=20
> Fix by using the safe accessors (loadsegment() and load_gs_index()) inste=
ad
> of home grown unsafe versions.
>=20
> This is CVE-2010-3698.
>=20
> Signed-off-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[...]

Avi, you surely knew this commit was buggy (specifically for i386
userland on an amd64 kernel) since you also committed:

commit c8770e7ba63bb5dd8fe5f9d251275a8fa717fb78
Author: Avi Kivity <avi@redhat.com>
Date:   Thu Nov 11 12:37:26 2010 +0200

    KVM: VMX: Fix host userspace gsbase corruption

I realise it wasn't ready for stable as Linus only pulled it in
2.6.37-rc3, but surely that means this neither of the changes should
have gone into 2.6.32.26.  Why didn't you respond to the review??

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-efgJDUh/ODBRktEGwNzA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATO8KJ+e/yOyVhhEJAQI/mA//QZPohtL2PHHG/LZR26RCW7Q8Vb7JRbMC
msz7AvnExvZophXIRME8AcmKBwn/GeKfaV4lCMXTVBSMYMg9TDhyhpOop1TUmn1o
AksgA2FZlrt7FYK/fzEaCAHst238kIu2Fvmk7/urydssbqNkt7wCz6+NohZ0s7/G
f9iXOM3uvPbyFib9SmSPGQtkGDl4kG3ZlOGynkxUsPVXvQmLUkOs58H/67h9mS+6
X3fcyAh1splXAC4cbaBW5jD07uapN5BSid9jTWg1bjsbWexXwhksnUCwaJ6ohroI
NG7TQaFRC9GlNkSXym4gt+j4V93p5EpXiR7CxSIGNYhWQy0T9Gzl/Sft0V2OaHjr
aoQAgL9dmpsg4NHiy3MNDuxzVUadtS5BEwolPA7TxjbCzpDLRAVnIndn42prwneA
2HRD/BUSdlXeEnca0+odg9HKDQTUmRFTusUv0RcL36yUDF45lYxsDojQGDlQGTim
j1v8PsucBcRY6DiXsKpZzlSlL83BdtomS/DnsgGzkHuTzr7mvkR0tQtJyuTNJCdp
prdz4DHsLx3QQWe2ExijG+QWF7oDo9cTUCwfB3MfsHkbj80VF1zpW1A8hrjK5d63
pHQbRahYw/+R6xcKbeBMw/8jukU6BpS9UeNIs1m2FlUsUHNjsSAoCvhUbgGqDxrR
t5xzl7xbAcw=
=3QH4
-----END PGP SIGNATURE-----

--=-efgJDUh/ODBRktEGwNzA--
