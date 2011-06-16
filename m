Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1FPQQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:16:36 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:37174 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697Ab1FPQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:16:33 -0400
Date: Thu, 16 Jun 2011 19:16:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 2/5] usb:dummy_hcd: connect/disconnect test support
Message-ID: <20110616161626.GV12230@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1308231068-24038-3-git-send-email-tlinder@codeaurora.org>
 <Pine.LNX.4.44L0.1106161101300.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zqkt5x/gGOIVPcL0"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106161101300.2204-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zqkt5x/gGOIVPcL0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 16, 2011 at 11:06:47AM -0400, Alan Stern wrote:
> On Thu, 16 Jun 2011, Tatyana Brokhman wrote:
>=20
> > This implementation adds a new proprietary device control requests (to =
be
> > handled by the dummy_hcd) that initiates a connect/disconnect sequence.
> > The bRequest value of the new control request is 0x52.
> > It is used by the user-space Unit testing application.
>=20
> This is not a bad idea.  On the other hand, it is slightly peculiar --=20
> it you're testing with real UDC hardware, you would do the=20
> disconnect/reconnect sequence by hand (unplug and replug the USB=20
> cable), not in software.

actually, this is quite useful. Specially for the controllers which
_can_ do soft-connect by toggling data pullups. I would rather have
these sort of thing maybe in composite.c, so that we can build tests
with all gadget drivers/controllers, not only dummy_hcd.

That said, I think now it's not the time to fiddle too much with these
details right now. So best to keep this in dummy_hcd until we know the
test tools are actually good.

--=20
balbi

--Zqkt5x/gGOIVPcL0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+ixaAAoJEAv8Txj19kN1K7IH/0pCYQfoJbc72RqLkrn53Gnp
aBgBdHmsf+4E8MKLfkZUZEmW8RMtV37E4hRGnG21AKiK8T9iY3G8vGqJXZcosZ9+
wam10gVgDlW14BZ/skzWxIU4HFH7LzVyaJ9YHY96B876do3iXUBsTSbCNDepOto9
08xNOJmk7d3yOPuFXvp+O3WfEdOuIOFif2Q8zsnJRDoj8TnsZ+C7T24Y/ybql9vn
HJqW8jsatDMq+HeV4I4b+JglkYnsmwXwbnBLkNWPzJBQeLO9U1QqEI7I/w02RmVI
Qbm3NPs+emAwRrxTcZgfRby97Nt989HMRPhPYuCK9/f1w4yqc4KmPqTDig50IVE=
=/aMP
-----END PGP SIGNATURE-----

--Zqkt5x/gGOIVPcL0--
