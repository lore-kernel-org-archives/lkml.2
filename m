Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab1LPEkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 23:40:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56346 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678Ab1LPEkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 23:40:15 -0500
Message-ID: <1324010389.2825.265.camel@deadeye>
Subject: Re: [RFC] modpost: add option to allow external modules to avoid
 taint
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        linux-wireless@vger.kernel.org
Date: Fri, 16 Dec 2011 04:39:49 +0000
In-Reply-To: <87mxatp3ty.fsf@rustcorp.com.au>
References: <1323752547.2825.101.camel@deadeye>
	 <1323879603-2961-1-git-send-email-linville@tuxdriver.com>
	 <87mxatp3ty.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-TiCjNho8ypdGs17NN30e"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TiCjNho8ypdGs17NN30e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-12-16 at 14:26 +1030, Rusty Russell wrote:
> On Wed, 14 Dec 2011 11:20:03 -0500, "John W. Linville" <linville@tuxdrive=
r.com> wrote:
> > In some cases, it might be desirable to package a module from an
> > external source tree alongside the base kernel.  In those cases, it
> > might also be desirable to not have those modules tainting the kernel.
> >=20
> > This patch provides a mechanism for an external module build to declare
> > itself as an "integrated build".  Such a module is then treated the sam=
e
> > as an intree module.
> >=20
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> > Any thoughts on this?  I'm thinking of adding this to Fedora kernels,
> > where I have been working to integrate the compat-wireless package as
> > part of the base kernel RPM.
>=20
> I don't think the feature is useful it it's too easy to disable.
> Experience has shown this with license tags.
>=20
> We really want to indicate "out-of-support" which is only a 1:1
> mapping to out-of-tree for upstream kernels.

Who are 'we' in this instance?

> How does Debian handle this?

All the modules in Debian's kernel binary packages are built in-tree.
Backported modules are patched in as necessary.

Debian includes many packages of OOT modules, but those are supported by
their respective maintainers and not the kernel team.  So for the kernel
team, the 'O' flag does not mean 'unsupported' but may indicate that
another maintainer should handle the bug (or it may also be irrelevant
to the bug).

> Perhaps it makes more sense to use the proposed module signing stuff in
> a simplified mode to mark built-with-kernel modules (eg. just put the
> sha of known modules inside the kernel).

Unlike commercial distributions, no-one is paying Debian for support
contracts and no-one can game the system by hiding OOT modules.  So it's
probably not worthwhile for us to use module signing at all.

However, supposing we did go down this route, I would guess that
checksums for ~3000 modules take up more space than the signature
checking code.  Instead, we could perhaps generate a key pair during
build, include the public key in the kernel and then discard the private
key.  (But getting entropy would likely be a problem for the key
generation.)

Ben.

> I think we should revert this change, meanwhile, and figure out what to
> do.
>=20
> Cheers,
> Rusty.
>=20

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-TiCjNho8ypdGs17NN30e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATurLlue/yOyVhhEJAQoyPw/8CYn6pSDro6kGmkyEOo9pwrJEqg/fGk1d
42iq0N+fO1Ki6Nkul0VtvQiuRvU4+NyXlQQOEGlZ+hXaFFG8Ikxeh4X0bGyQPOUe
V+lq2SKajULwglbkeGn92nlxiSzlHP9e7JlYvW8a2gXT5L4kav7uSfN88oUsKCNc
I465RjM3ZteOqHJ3/PdcaQhs/inZAflCJuXz6HSP+VYHrfvZLnTwgc9t23OggECK
S9VedTOT+ZAElMYJNWxauZHv+ydujW9nt/7X9C/HUt5AV+kqbqMIoZuAM3vc7qbb
xP3isVqFsIhunI1tXeCT9wLg2qM0pQRqPUmlD0DDQoPqQb4TzFAK4czqKtiK/mNX
Y42M2vui2oJANyUi6/LPHNv1h5Nl5rIIkaDjshTHK68sG0SYfV5wdnMxPchuc9Xm
I5MGt39Unx7pnCLWqhkpPtaJqsz3c3HMj6bxHmn7L+OICBi1pUlRBIcF0F6YZ/lB
imRoRUxKGWGRTfqZJ8xrrgVPNGnATS/7FYkNJXUCcYjT9wXUaNXv/vFtEWzTyryc
QuKsPnA31WfelvEWiDWG9Zud6A+Dw0Bn3QTkKG6/DX2YnPN90wbyrhYF+ahAoai9
3XGoTMM/JSbFvyCR7U+g77RlBOnsr9Wt8VilvUElZE+vE43qZtKfKl4HkhIu3XaN
N9r4m4vgUF0=
=nH8A
-----END PGP SIGNATURE-----

--=-TiCjNho8ypdGs17NN30e--
