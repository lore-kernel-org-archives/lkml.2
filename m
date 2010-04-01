Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0DAHfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:35:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39688 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0DAHfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:35:38 -0400
Date: Thu, 1 Apr 2010 18:35:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: linux-next: build failure after merge of the final tree (hid
 tree related)
Message-Id: <20100401183530.516bbca6.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.1004010817420.8345@pobox.suse.cz>
References: <20100401170639.9f2fe605.sfr@canb.auug.org.au>
	<alpine.LNX.2.00.1004010817420.8345@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Apr_2010_18_35_30_+1100_Juv1ed00kvd2lyd9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Apr_2010_18_35_30_+1100_Juv1ed00kvd2lyd9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Thu, 1 Apr 2010 08:18:43 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrot=
e:
>
> On Thu, 1 Apr 2010, Stephen Rothwell wrote:
>=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/hid/hid-picolcd.c: In function 'picolcd_debug_reset_write':
> > drivers/hid/hid-picolcd.c:1343: error: implicit declaration of function=
 'copy_from_user'
> > drivers/hid/hid-picolcd.c: In function 'picolcd_debug_eeprom_read':
> > drivers/hid/hid-picolcd.c:1407: error: implicit declaration of function=
 'copy_to_user'
> >=20
> > Caused by commit 9bbf2b98ba11d00bd73e3254e15cfe17ccaff6ba ("HID: add
> > experimental access to PicoLCD device's EEPROM and FLASH").  Using copy_
> > {to,from}_user requires the include of linux/uaccess.h.
> >=20
> > I have reverted that commit for today.
>=20
> Hmm, on which arch did this bomb out? I wonder why it is building fine fo=
r=20
> me.

PowerPC (see above).  It could also be some interaction with another tree
in linux-next.

> Anyway, I have added the include, as it is obviously correct(tm), thanks=
=20
> for reporting it.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Apr_2010_18_35_30_+1100_Juv1ed00kvd2lyd9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku0TMIACgkQjjKRsyhoI8wd7QCfQiPUx+A79YZhZosGZyuLUAN4
W7kAn2WuOr7CWIgwVdXCSeoNQHF66s17
=+M7A
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Apr_2010_18_35_30_+1100_Juv1ed00kvd2lyd9--
