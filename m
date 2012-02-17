Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2BQXjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:39:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38233 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2BQXjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:39:24 -0500
Date: Sat, 18 Feb 2012 10:39:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: add config NUMA stub to all architectures
Message-Id: <20120218103914.39e7e1eb69e1fd29275c4849@canb.auug.org.au>
In-Reply-To: <20120217134404.GA11353@merkur.ravnborg.org>
References: <4F3E42E0.4030108@openvz.org>
	<20120217120815.25909.15632.stgit@zurg>
	<20120217234508.8293a84fb3ebb7fed6d60ec3@canb.auug.org.au>
	<4F3E56DA.3050203@openvz.org>
	<20120217134404.GA11353@merkur.ravnborg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__18_Feb_2012_10_39_14_+1100_l9Co54daMOZkqbyW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__18_Feb_2012_10_39_14_+1100_l9Co54daMOZkqbyW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Fri, 17 Feb 2012 14:44:04 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> > Seems like Kconfig allow config option duplication, but it use default =
state from first.
> > If we add "config NUMA\n def_bool n" somewhere in generic Kconfig, defa=
ult will be n if
> > Kconfig see this declaration first.
> Correct.
> And as n is default there is no need to specify it.
> But please add a help text that explain the symbol - even if it is not
> visible in menuconfig.

So does that mean that a simple

config NUMA
	bool
	help
		some help text

in mm/Kconfig will have no effect on the defaults and dependencies if
"config NUMA" is specified elsewhere?  (except to add the needed
__enabled_CONFIG_NUMA defines, of course).  If that is the case, then
that is what we should add, right?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__18_Feb_2012_10_39_14_+1100_l9Co54daMOZkqbyW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPuUiAAoJEECxmPOUX5FEREcP/RT0vFXyKbNBhuSRfO3QRSG/
HTf9RLl6+solZU69d5F3lkusTQfIyMV657oClmrvygxsrp6OpqnD8oT/ueMcL+MV
c384bnRaoBC/7d4E6K1OofaoRnujx9Sxf0ZCWIYuKdWGWj4EHYn8ZAjGU7CObwzX
ZXLU9ioVpyn4S00xluzIbJdM8yZ//WNtiozrJinH9EIexSCjwXfZ/w4hmzc90lOj
x3BEHUg33vui8oBy97l2E9LFQIxt+Kb8saBJf44clzMF5vo/OBdWDXPpOJRfE01m
MDiWl05y+JTxhtFg81LQCv6y6S4YYooq9eJGXvJUF9BstY9e6/hDMVjxN4DKw1FV
4U1fs3UfNjJ6aM/V8dsZseVBRNVz2o3HAHRBO72sZwBPU8Pwp8EcNwad2EbjuWCe
eUz8WO4iDJhXdXc7BnWwsd/KtbMWHFLhDMdEtmMhGZ5tZa0JpsAn7+essadadZTE
u9Ls/c4xmu67SMsW60N/oVgi+v/voHFh/BjJ2YXXKw6MlhigZvmoJA498TMgvk87
Fd78aqZXWi/i6dz5Jpyy8g2ZS+E/BA0Ds9GFLc9oiKl9ZjutZe70tKTo7LLcVcuZ
5r7uA2Rnad7ipJeeBLq4CS+psD62C2ehpOwuTL+Mq8l7i+MzG/dR5ynA5iIQH0za
j/TLhEpYz4GV1nXNSxIX
=h9RU
-----END PGP SIGNATURE-----

--Signature=_Sat__18_Feb_2012_10_39_14_+1100_l9Co54daMOZkqbyW--
