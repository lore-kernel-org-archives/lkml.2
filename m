Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0IISS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:18:56 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:49597 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0IISSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:18:52 -0400
Date: Thu, 9 Sep 2010 20:17:15 +0200
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
Message-ID: <20100909181714.GA14951@darkside.kls.lan>
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
References: <20100818155128.GA24363@darkside.kls.lan>
 <4C6CA31D.6030407@canonical.com>
 <20100819193146.GB32665@darkside.kls.lan>
 <4C6E2833.6080407@canonical.com>
 <20100820090824.GA23186@darkside.kls.lan>
 <4C7505A2.3000402@canonical.com>
 <20100830181954.GE31068@darkside.kls.lan>
 <4C7E3DE0.7030209@canonical.com>
 <20100901195617.GD32589@darkside.kls.lan>
 <4C80BA81.20701@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <4C80BA81.20701@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 03, 2010 at 05:06:09PM +0800, Ike Panhc wrote:
> I look at the DSDT again and again but unfortunately can not find anything
> may cause the bluetooth device initial failed. BTEN looks like the switch
> for EC to turn on/off bluetooth, BTST records the status of BTEN and BTPS
> means bluetooth present. But no idea why initial failed after BTEN=3D1

Is there some way to trace ACPI calls under Windows (XP Home)?
I could then have a look at what happens when I Fn-F5 BT off.

> So I fall back to your suggestion. Have a module parameter to tell module
> not to register rfkill for bluetooth.
> I prepare the driver and please spend some time testing. Driver is at
> http://kernel.ubuntu.com/git?p=3Dikepanhc/ideapad-laptop.git;a=3Dblob;f=
=3Ddrivers/platform/x86/ideapad-laptop.c;h=3Dc4cf46a363f3f72d6db5339ec326d2=
82d7e58183;hb=3D26a58948693b7d25960299a8025e569e68f28937
> and you may use "insmod ideapad-laptop.ko no_bt_rfkill=3D1" for your S12.

Hmmm, with this version and no_bt_rfkill=3D1 I run into the same problem
as without the ideapad module: If I switch BT off in Windows and reboot
to Linux, the device remains invisible and I have no chance to switch it
back on again :/
I guess this is because the initial device activation does currently
only happen in ideapad_register_rfkill() via rfkill_init_sw_state()
which is not called if no_bt_rfkill=3D1.
A manual call to ideapad_rfk_set() (or ideapad_sync_rfk_state()?) in the
no_bt_rfkill=3D1 case would very likely solve this, but I don't know how
to provide this call with the correct arguments.


regards
   Mario
--=20
=2E.. aber nur deshalb blueht Autoritaet, weil die meisten Menschen
Feiglinge und manche Menschen Diebe sind.
                                              -- Robert A. Wilson

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTIkkqhS+e2HeSPbpAQKunwf+MvdUpXe+MG+Fr0U4YMnvy4R9LOKAZfxj
Yh7G7LKcg5O+c3vPsXlTc49zp4soO/jkuxtN/ewrcbM/PzC1ifnNpv1e8UdYk/zN
O/RD36NB9fhxhHKBEeET6ZRJ5d5jG+MbxkbQ3WttbeVscJGvWP50dYHaqRAka9Ym
72qkGview7kp0jipxtyseJrOhtsbhowFUp8oC0YsySQGzN+med7MJ8XOdaLlgpis
JFpOkfD5DtTTFgZQjz8SWhMSVMQgBlhrg0o9jvNDpR58fJivtGpp01HprRJ+t8O9
OHMMjjCSemWsML3TVotCQOBMO65dBGZpq2+Qnu1dQYTQQE44R4Cq6w==
=zHzK
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
