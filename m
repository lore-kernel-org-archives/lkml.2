Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0CUN6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:58:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:52604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab0CUN6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:58:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,283,1267430400"; 
   d="asc'?scan'208";a="606298535"
Date: Sun, 21 Mar 2010 21:58:36 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       ben@decadent.org.uk, gregkh@suse.de
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT
 entries in i915
Message-ID: <20100321135836.GA11661@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, David.Woodhouse@intel.com,
	dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
	gregkh@suse.de
References: <1268258994.2183.14.camel@carter>
 <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
 <20100311083404.GG6896@zhen-devel.sh.intel.com>
 <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
 <20100319132723.118cc16a.akpm@linux-foundation.org>
 <ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.03.20 14:04:56 +0100, Miguel Ojeda wrote:
> On Fri, Mar 19, 2010 at 9:27 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 11 Mar 2010 16:54:26 +0100
> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
> >
> >> Attached dmesg, lspci -vv, config and xorg.
> >>
> >> When the X server crashes, the kernel does not report anything
> >
> > This seems to have gone all quiet?
>=20
> It seems so, I was about to ping Zhenyu.

Could you try recent X.org intel driver release? Your failure X log=20
showed some pretty old UMS driver's render flush time out message,=20
I think whose version never has been well tested with new kms/gem stuff.

>=20
> >
> > As this was a 2.6.32->2.6.32.4 regression, I assume that it's also a
> > 2.6.32->2.6.33 regression?
>=20
> Yep. All kernels I tested since 2.6.32.4 crash, including 2.6.32.10,
> 2.6.33 and 2.6.34-rc1. See my original message for more details about
> the crash.
>=20

Could you bisect? I doubt it's caused by David's patch, as if it is, you
will have trouble at early agp init time, instead of current problem looks
like something causing rendering hang..and I can't think of how mapping GTT
to a scratch page could cause problem in case GTT bar is truely 256K.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkumJgwACgkQsQQaM014GCe2cgCbB8LJnqn7n7J++lA8Pd+TfBQb
2BQAn2sYv0DZuSniLTcf9F3cX+cGIgVl
=gQHY
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
