Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab1FIH16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:27:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37542 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab1FIH14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:27:56 -0400
Date: Thu, 9 Jun 2011 17:27:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the final tree (staging
 related)
Message-Id: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Jun_2011_17_27_45_+1000_V0D5c.8UiXL+VFtg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jun_2011_17_27_45_+1000_V0D5c.8UiXL+VFtg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/staging/brcm80211/brcmsmac/ampdu.c: In function 'wlc_ampdu_dotxstat=
us':
drivers/staging/brcm80211/brcmsmac/ampdu.c:840:17: error: invalid operands =
to binary ^ (have 'volatile u32 *' and 'int')
drivers/staging/brcm80211/brcmsmac/ampdu.c:840:17: error: invalid operands =
to binary ^ (have 'volatile u32 *' and 'int')
drivers/staging/brcm80211/brcmsmac/ampdu.c:848:8: error: invalid operands t=
o binary ^ (have 'volatile u32 *' and 'int')
drivers/staging/brcm80211/brcmsmac/ampdu.c:848:8: error: invalid operands t=
o binary ^ (have 'volatile u32 *' and 'int')
drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_bmac_update_slo=
t_timing':
drivers/staging/brcm80211/brcmsmac/bmac.c:186:3: error: invalid operands to=
 binary ^ (have 'volatile u16 *' and 'int')
drivers/staging/brcm80211/brcmsmac/bmac.c:186:3: error: invalid operands to=
 binary ^ (have 'volatile u16 *' and 'int')
drivers/staging/brcm80211/brcmsmac/bmac.c:190:3: error: invalid operands to=
 binary ^ (have 'volatile u16 *' and 'int')
drivers/staging/brcm80211/brcmsmac/bmac.c:190:3: error: invalid operands to=
 binary ^ (have 'volatile u16 *' and 'int')
drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_setband_inact':
drivers/staging/brcm80211/brcmsmac/bmac.c:234:2: error: invalid operands to=
 binary ^ (have 'volatile u32 *' and 'int')
drivers/staging/brcm80211/brcmsmac/bmac.c:234:2: error: invalid operands to=
 binary ^ (have 'volatile u32 *' and 'int')
drivers/staging/brcm80211/brcmsmac/bmac.c: In function 'wlc_dpc':
drivers/staging/brcm80211/brcmsmac/bmac.c:311:6: error: invalid operands to=
 binary ^ (have 'volatile u32 *' and 'int')

(and lots more)

Also in several other files in drivers/staging/brcm80211/

Also:

drivers/staging/comedi/drivers.c: In function 'comedi_buf_alloc':
drivers/staging/comedi/drivers.c:505:37: error: 'PAGE_KERNEL_NOCACHE' undec=
lared (first use in this function)
In file included from drivers/staging/comedi/drivers/addi_apci_035.c:7:0:
drivers/staging/comedi/drivers/addi-data/addi_common.c: In function 'i_ADDI=
_Attach':
drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error: impli=
cit declaration of function 'virt_to_bus'

(Also several other occurrences of that one)

I left this build broken, but these should be fixed if you are going to
remove STAGING_EXCLUDE_BUILD.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Jun_2011_17_27_45_+1000_V0D5c.8UiXL+VFtg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8HXxAAoJEDMEi1NhKgbsE2UIAJCKz4USINxHE2d6C7ofvWh1
nr/TpKczn8NUR9Fe3CI9UEw9TbsnWuO43Gxmr34Xtqev4XaZuWmETTYCFqBqA/Fz
TUqmdA0ilDTwTjLlKBmBtmgGV8LvoEmv1NgeiZbiKYfI+qepdSIvSEftjSHDcL3Y
IX4SjeE32hNcP0mGpxJ1deeqLlBq0U/lM6LrMyY9Xr7LLojicjgePWDtzeTAbzkS
zAvIpuIwVIGOe4IczP2oLFwnB+vtBFefiWJfMbLFjzO7tVGEZ1wcbjixBYi+K2jB
MjA8ixQ3Fg+guzHsfkvmutDtYX062sqcyoHLkLG8CtVBPrLdaWqNaBrF7iOiV/4=
=gtUL
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jun_2011_17_27_45_+1000_V0D5c.8UiXL+VFtg--
