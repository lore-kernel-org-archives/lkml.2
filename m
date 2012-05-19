Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab2ESWjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 18:39:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49842 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551Ab2ESWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 18:39:29 -0400
Date: Sat, 19 May 2012 23:39:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq_domain: Standardise legacy/linear domain selection
Message-ID: <20120519223924.GC16590@opensource.wolfsonmicro.com>
References: <1337428920-7674-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120519202258.D9B903E03B8@localhost>
 <20120519205400.GB16590@opensource.wolfsonmicro.com>
 <CACxGe6vqzOyeLf8okuo2OdTFUaB_E=5KFSN11n05vgEyJzpmBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <CACxGe6vqzOyeLf8okuo2OdTFUaB_E=5KFSN11n05vgEyJzpmBQ@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 02:59:51PM -0600, Grant Likely wrote:

> It will actually be like all legacy users switched to creating an
> linear mapping, and then either associating already allocated
> irq_descs with that domain or telling the domain to pre-map a specific
> range of irq_descs (and manage allocations).  Those two use cases will
> be separate APIs.  I don't think they should be combined (at least
> from my current thinking) because it depends on whether or not the
> irq_descs are already allocated.

Hrm.  Given that the target for this API is drivers that mostly don't
care and are only supporting the current linear mappings in order to
allow their GPIOs to be used with generic drivers that only want an IRQ
I'd expect we'll wind up with a similar helper somehow.  Copying a
number around for irq_start isn't much hassle for individual drivers but
having to worry about more than that seems like too much effort, they
shouldn't have to care about the management of irq_descs.  It'd be more
work and it'd make it more painful for platforms to change between the
preallocated and dynamic models.

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuCDYAAoJEBus8iNuMP3dLXoP/2cVnRn5bcFzJLblFwMRgwLP
J8f+sGUw8f94wgbLZ8a0tPjGUCDN2z38/KabAK/G3nMeW2n/dFJJA3s4AJhDoDZa
Ry61ASwOf+XpoLL0kxEBAuncBffuwtUI0wyNkuEAgxsRY59otPlWGpPfcWJRnSYF
Mm+ThuCfd3/eYbizGT0GzkD/4SHwHVbT5wVn0VU0HoQU4YNHlYDH4T65z3OuaD6Q
IJk3dqO8Mq3TPRQ95u6wPptjZZO5heC+3DwE+ieYLC1ij83ts1eG3nzkcLcEoSa+
6eabQWoq436SiBYzq3IdgYxvzRzjc5QZw7oD8dAOnTjDqNITPWkmvf34RPNkqWNq
6ojOH2zCCKtLOq1umm5+UhC68Umza0eHVX1mo9GOUJKEDhxoFqdwQb0w7f0H/t3C
aBjOezn/ZzUQM1uD0lGcaqkmXDtbKAQRgFSo10g7hshnbGDFNkpawofK+S/RX5Al
UuwLV1jT+1BJKjjyHhpeGJYUQQejVMmbpL2eGJvduSaWqLgNS/1yrQvWoGEcR9bc
mRH1L8q/l4gu6cH38nGMBgiIUNdgg7RfTiAjvmAYUChR9WvC6UWCzOuIwnPLJOUp
JV2sz31urHnkYcGHMwoPbA1Kwoy+HvxM2FDXk4J82S16UsuGH67QWislpN8Q15kV
2IEROGgsJtmkADKBWrFr
=Kiym
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
