Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055Ab2EQDnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:43:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34539 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760983Ab2EQDnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:43:03 -0400
Message-ID: <1337225964.2730.11.camel@brekeke>
Subject: Re: [RFC v5] UBI: Fastmap support (aka checkpointing)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Thu, 17 May 2012 06:39:24 +0300
In-Reply-To: <1337201522-86521-1-git-send-email-richard@nod.at>
References: <1337201522-86521-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-12x6ye6TYGX8mFPlrknX"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-12x6ye6TYGX8mFPlrknX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 22:51 +0200, Richard Weinberger wrote:
> This is a bug-fix release. v4 handled static volumes wrong.
> v6 will address everything that Artem pointed out.

Hi, I'll try to review this further, but few points I'd like to
highlight.

1. We'll need to re-structure the code a bit and rename scan.[ch] to
attach.[ch], all data structures like 'struct ubi_scan_volume' which you
re-use we will also need to rename and remove the "scan" word, etc. I am
willing to do this preparation.

2. You need to re-use the scanning code we have for scanning the fastmap
volumes, I think. May be you need some amendments there, but currently
you have more duplication than needed. You'll just plug more of your
code to the attach.c file: check if there fastmap, if yes, read it and
scan the internal fastmap volumes by re-using functions in attach.c. So
all the fastmap reading/checking/manipulating stuff is in fastmap.c, the
scanning and interpreting is in attach.c.

Again, I am willing to do corresponding preparations for you, you'll
need to amend your code then.

Also, I think you probably do not have to split your patches. For me it
looks like there is a lot of work needed anyway, so you could just send
it as one patch so far, to make things easier. Because reviewing this
stuff by reading patches is too difficult anyway, and the reviewer has
to apply it and review / navigate the real code, and just look sometimes
to the patch.

--=20
Best Regards,
Artem Bityutskiy

--=-12x6ye6TYGX8mFPlrknX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtHLsAAoJECmIfjd9wqK0DqUP/1dK3mLWOZCRkIfhy12YaTyf
EdWZJ8lRlCY3P62bQSStWOtuJqv+Ltm23U664ORTUnstaYOD94npu/cj3qmr4Tni
iV/NaEYbo4M+xm8mtDvLVuNHQ37jyzEw7EF+xEDYtgeU1diMJ8elHSiFdm6HFeLh
0+GN7ka6BWbDZJFNdBIABOLH4xkwC7DnMZzEOxVCt9XfmFXC/Ho2LUoiCAETsfsH
8SopSD2Ek68f/OgbUBnVDSM9lu+EpWtOZjnSS0SVqrjGHJdv5VTA3FFAXnOm5goF
ZzI7Ul+1YX1tQJzIInsA16h+r9VihxEoQDP9EzAtakrHmbhQoNO1zsd4EVL+dQjW
gtEYYO60u35X40BpBlDV9oOyH/SbSnMLSQdjUc8MteLO4Xz3+3McATeHJ6Hn9NFt
w52QeI+kajHD+Z68L1+1XtASjatT0+b6wbYLcHjRTHY1K+QczArt5K1rw3U1ZVPA
ypIxKtWgfJNcyDz+eWxWrOlettKcoNDDSy/n5obQOnqfbotr1uF5WJI303iz7PDg
WF2lURD9GumCOtsVL2WJvglvwacuOFiOLOp+s0Ko/NHtoKJJocgzohXNhvpoW5gd
Fzfz7VENqEGtPvKvDSlJlZ9BWNRSCPRsFq1lLnWmdQxuEULCFj3HHWQiK8KIhS+Q
9D04GcwOGaQjShZx2JN6
=+oTh
-----END PGP SIGNATURE-----

--=-12x6ye6TYGX8mFPlrknX--

