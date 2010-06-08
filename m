Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0FHGmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 02:42:52 -0400
Received: from smtp-OUT09A.alice.it ([85.33.3.9]:4785 "EHLO
	smtp-OUT09A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0FHGmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 02:42:49 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jun 2010 02:42:49 EDT
Date: Tue, 8 Jun 2010 08:32:26 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>,
       Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Stephane Chatty <chatty@enac.fr>,
       Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] HID: Add Support for Setting and Getting Feature
 Reports from hidraw
Message-Id: <20100608083226.2dac88d2.ospite@studenti.unina.it>
In-Reply-To: <1275969108-14948-1-git-send-email-alan@signal11.us>
References: <1275969108-14948-1-git-send-email-alan@signal11.us>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Jun_2010_08_32_26_+0200_4eITh4doWcuCJKD0"
X-OriginalArrivalTime: 08 Jun 2010 06:32:33.0750 (UTC) FILETIME=[60D38760:01CB06D4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jun_2010_08_32_26_+0200_4eITh4doWcuCJKD0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon,  7 Jun 2010 23:51:48 -0400
Alan Ott <alan@signal11.us> wrote:

> Per the HID Specification, Feature reports must be sent and received on
> the Configuration endpoint (EP 0) through the Set_Report/Get_Report
> interfaces.  This patch adds two ioctls to hidraw to set and get feature
> reports to and from the device.  Modifications were made to hidraw and
> usbhid.
>=20
> New hidraw ioctls:
>   HIDIOCSFEATURE - Perform a Set_Report transfer of a Feature report.
>   HIDIOCGFEATURE - Perform a Get_Report transfer of a Feature report.
>=20
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---

Thanks Alan, I am going to test this quite soon.

TBH, when I was thinking about how to extend hidraw I thought we could
have added a new report_type field to struct hidraw_report_descriptor,
in order to re-use the HIDIOCGRDESC ioctl handler itself, adding then a
HIDIOCSRDESC for setting the report. This looked cleaner to my eyes,
but I didn't actually implement this, so I don't know if it was
feasible, for instance one problem I didn't investigate further was
about the default value of the aforementioned report_type field in
order to keep the current behavior of HIDIOCGRDESC.

Regards,
   Antonio.

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__8_Jun_2010_08_32_26_+0200_4eITh4doWcuCJKD0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwN4/oACgkQ5xr2akVTsAHaxwCgnbHHaDzQfJp3CE3MLkQiUGUh
biUAnR9QWfMf79hgN5Hv9tHu7A44V0xH
=ibSj
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jun_2010_08_32_26_+0200_4eITh4doWcuCJKD0--
