Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0IOLt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:49:56 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:43473 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0IOLtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:49:52 -0400
Date: Wed, 15 Sep 2010 13:48:20 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: Ike Panhc <ike.pan@canonical.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control
 rf/camera power
Message-ID: <20100915114820.GA22415@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	Ike Panhc <ike.pan@canonical.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Corentin Chary <corentincj@iksaif.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"Brown, Len" <len.brown@intel.com>,
	Matthew Garrett <mjg@redhat.com>
References: <20100820090824.GA23186@darkside.kls.lan>
 <4C7505A2.3000402@canonical.com>
 <20100830181954.GE31068@darkside.kls.lan>
 <4C7E3DE0.7030209@canonical.com>
 <20100901195617.GD32589@darkside.kls.lan>
 <4C80BA81.20701@canonical.com>
 <20100909181714.GA14951@darkside.kls.lan>
 <4C89D3C0.7040105@canonical.com>
 <20100910071155.GA1263@darkside.kls.lan>
 <4C909C57.5030107@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <4C909C57.5030107@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 15, 2010 at 06:13:43PM +0800, Ike Panhc wrote:
> On 09/10/2010 03:11 PM, Mario 'BitKoenig' Holbe wrote:
> > 	rfkill_init_sw_state(priv->rfk[dev], 0);
> eh.. after review the code, the rfkill_init_sw_state shall not give 0 as =
the default
> value. I shall read the value from EC and set reasonable value.

Well - probably :)
The current behaviour results in each device becoming unblocked no
matter what state it had before.

> > 	if (no_bt_rfkill && (ideapad_rfk_data[dev].type =3D=3D RFKILL_TYPE_BLU=
ETOOTH))
> > 		ideapad_rfk_set(???, 0);
> Do you mean driver still setup the rfkill for bluetooth, but we can not b=
lock
> bluetooth when module parameter set to 1? This idea is better then no_bt_=
rfkill.
> Will modify the driver.

Well, not really... I mean: in the no_bt_rfkill=3D1 case the driver should
(try to) unblock the bluetooth device in order to activate it to make it
further manageable via it's own (hci) rfkill switch.
I don't think setting up the ideapad_bluetooth rfkill is necessary for
that. Not setting it up is IMHO the right direction. Just the device
activation is missing.


Mario
--=20
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTJCyhBS+e2HeSPbpAQKllgf/a37tMSBXNoEgyUayAp7cn5/vt/wMUSTs
dJHRZiJb4Mvp1m+/7v41+TOW8HAMEqFfuCv8WgVugE027BbVS7yNWRAJuJJuoaMW
7obwBYsLM6PyqCyAOQ/L/y4L3mg+Grfw+PF1rsqxMlLKqU4rx9j1BWlNxjcObrEw
oi2naSaRw1MzzA690HEDyXlNtE4ZLc9iOKQek3SNFy76u5tOqTFn+G1IlGRQfpAf
4hgYwIi2yOCXDk7KdvP9fihgkmyAZg9pKlbCzzlvEtkyublsg9eNWcyE6DfWOCVI
QJWpAeYXKkbtq5zRvqqrlvq5CmgoAIZKpaGVnAz52I9EG2cvLyrqwg==
=TJAN
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
