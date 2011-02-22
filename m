Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1BVGRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:17:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45615 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1BVGR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:17:29 -0500
Date: Tue, 22 Feb 2011 17:17:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the i2c tree
Message-Id: <20110222171720.59019382.sfr@canb.auug.org.au>
In-Reply-To: <20110221105858.197cbf1d@endymion.delvare>
References: <20110221153522.8a0b29bf.sfr@canb.auug.org.au>
	<20110221105858.197cbf1d@endymion.delvare>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Feb_2011_17_17_20_+1100__c.eOzT1h_orepO_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Feb_2011_17_17_20_+1100__c.eOzT1h_orepO_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Mon, 21 Feb 2011 10:58:58 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>
> On Mon, 21 Feb 2011 15:35:22 +1100, Stephen Rothwell wrote:
> > Hi Jean,
> >=20
> > After merging the tip tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced these warnings:
> >=20
> > drivers/i2c/i2c-core.c: In function 'i2c_do_add_adapter':
> > drivers/i2c/i2c-core.c:799: warning: 'attach_adapter' is deprecated (de=
clared at include/linux/i2c.h:149)
> > drivers/i2c/i2c-core.c:804: warning: 'attach_adapter' is deprecated (de=
clared at include/linux/i2c.h:149)
> > drivers/i2c/i2c-core.c: In function 'i2c_do_del_adapter':
> > drivers/i2c/i2c-core.c:985: warning: 'detach_adapter' is deprecated (de=
clared at include/linux/i2c.h:150)
> > drivers/i2c/i2c-core.c:988: warning: 'detach_adapter' is deprecated (de=
clared at include/linux/i2c.h:150)
> >=20
> > Introduced by commit 95529c656b97b08c7a92504f98650a229f03ae04 ("i2c:
> > Deprecate i2c_driver.attach_adapter and .detach_adapter").  We normally
> > fix up as many uses of an interface as possible before deprecating it .=
..
>=20
> These are the core locations where the deprecated callbacks are called.
> Ideally they would _not_ emit warnings, are these are legitimate and
> can't be removed before all drivers relying on these callbacks have
> been fixed. If there is a way to silent these warnings, please let me
> know, as I don't know of any.

You could build just that file with -Wno-deprecated-declarations, or put
the deprecated stuff into another file that is built with that flag.
We did the latter with pci_find_device (see commit e8b553bf4b19c "PCI:
disable pci_find_device warnings when deprecated pci functions are
enabled").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Feb_2011_17_17_20_+1100__c.eOzT1h_orepO_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNY1TwAAoJEDMEi1NhKgbssBcH/ikDtTGsGtcnY26ln33A+dIY
jzgNzsPqWniy5CgG7gauR+/SwoTYxxr8tZvStRdRZxcJdSu/Dpbx3H+tUIbG3I6n
8yJLM52D1+VAOndmjuci3jQPhNV+3MXQJRzYR6lqC12Af0WlfvHS4X50nAQd5QyP
hhy7S5jo2sAE7vEqBTvNvfridjnBxgzI5GDdBAfiHKAL0vkNba8Gf9T/bkv6pNs9
+rGg6VVLwH7BRWlX/TDhw3WFhIoq22YV21SrRLpOh9cwzNxItei+I6eZ0syiqN9I
fZLPujm7eZc3/1G+y6yNeMJTfLnN0TVG4qIemtoEYCYMgI5ablfhWXYVGBqhqjU=
=OdbM
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Feb_2011_17_17_20_+1100__c.eOzT1h_orepO_--
