Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab0HTJJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:09:10 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:33592 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0HTJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:09:08 -0400
Date: Fri, 20 Aug 2010 11:08:24 +0200
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
Message-ID: <20100820090824.GA23186@darkside.kls.lan>
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
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
 <1282127719.2747.211.camel@localhost>
 <20100818155128.GA24363@darkside.kls.lan>
 <4C6CA31D.6030407@canonical.com>
 <20100819193146.GB32665@darkside.kls.lan>
 <4C6E2833.6080407@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <4C6E2833.6080407@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 20, 2010 at 03:01:07PM +0800, Ike Panhc wrote:
> Could you attach or upload the DSDT of S12 somewhere I can reach?

http://sandbox.fem.tu-ilmenau.de/s12/dsdt-s12-via.dsl

> I check DSDT for S10-3 and B550, return value of _CFG is fixed.
> [Ref: http://people.ubuntu.com/~ikepanhc/DSDTs]

Looks more fixed than on my S12, indeed.
I don't really speak AML, but while S10-3 ILDD (called from _CFG) seems
to read fixed values only, here on S12 PHSR (called from _CFG) seems to
do some kind of I/O operation. I'm not sure about this, but it somehow
looks like.

> On 08/20/2010 03:31 AM, Mario 'BitKoenig' Holbe wrote:
> > Once the cfgbit is 0xc0000 it's stable, i.e. modprobe -r ideapad-laptop;
> > modprobe ideapad-laptop doesn't change anything.
> sounds like we need an exception handle for detecting camera

Why? The camera is always detected - bit 19 is always set, 0xc0000 and
0xd0000 only differ in bit 16. Bit 19 btw. seems to be the only fixed
bit in S12-VIA _CFG :)

> > [  682.260288] ideapad_acpi_add(): cfg=3D0xc0000
> As I know the cfgbit for lower 16bit shall not be all zero.

Mh, judging from S12-VIA _CFG they definitely are zero here.

> > So, forcing the existence of the killswitch enables the bluetooth
> > device. I'm also able to switch if off again - the bluetooth device
> > disappears. Trying to switch it back on then fails - the bluetooth
> > device does not appear again. But this case doesn't work all that well
> > anyways even with cfgbit 0xd0000:
> bluetooth device shall disappear after disable from EC. But if can not be=
 enabled
> again, ahh.....

> > [  155.628052] usb 4-1: new full speed USB device using uhci_hcd and ad=
dress 4
> > [  170.740049] usb 4-1: device descriptor read/64, error -110
> > [  185.956033] usb 4-1: device descriptor read/64, error -110
> This looks like the device is power up, but usb host unable to recognize..

The bluetooth device seems not to initialize well enough to answer (110
is ETIMEDOUT).

> > Sometimes it doesn't even come back at all on unblock. Seems like the
> > bluetooth device doesn't really like to be powered off and on that way.
> did you see any kernel message said timeout when it does not come back at=
 all?

No, when I said "does not appear again" and "it does not come back at
all" I meant I see not a single message in dmesg about anything
happening.

> If the rfkill for the whole bluetooth module makes trouble, I prefer not =
to
> do it. User will feel confused if the device does not come back and the
> rfkill of hci0 offers the function user need.

Hmmm, maybe provide a module parm to block rfkill devices and default it
to 1 on S12? Users would not need to care too much then but can change
it if they like...

> > Please let me know if I can provide more testing - and what kind of :)

Okay, did some more...

I played with the hardware killswitch under Linux. The bluetooth device
disappears and re-appears there and always seems to initialize
correctly. No USB read errors this way.

I also played with the soft killswitch under Windows. The bluetooth
device disappears from device manager and re-appears on unblock
(together with the Windows device plug sounds). This looks to me like
the ACPI killswitch is used for it.
No initialization-problems here, the device always comes back fully
operational. So, Windows doesn't seem to suffer from a bad
initialization.

I'm not exactly sure what this means - especially because I don't know
how the hardware killswitch works internally.
It *could* mean, the initialization problem is proably something that
could be dealt with in the USB layer long term (and would then probably
not have to be worked around anymore in ideapad_laptop). I'm not sure
about this, because this would mean the hard killswitch power-cut
somehow differs from the soft killswitch power-cut.


Mario
--=20
As a rule, the more bizarre a thing is, the less mysterious it proves to be.
                                    -- Sherlock Holmes by Arthur Conan Doyle

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEUAwUBTG5GCBS+e2HeSPbpAQKD2Af4nJEK4Oi0XK9QSu9m2REcA/DB6ZBEyieU
mXZHGgrsgSSChG7ea7N3slaY6He5KJswgc+eiqxARaipjr+UZq3Aj80/N0QYYbz/
Gqf6Hudsu0fRNq2SPMEiNfs7K76hPWYsCUvyquw5DF5ZEm9gHePJqHIi80O/isbQ
NqEQB3q6iosh3VQTmkBbBkSKvY6MTGHUQB4pNig49Mxt/s2ulVahzqHzZyhZJQKc
8GAuRP3fEPtllRhhFlbM7yjpWY5OjxH4xJoFNyH6e38R6T+Gal7CaAiBww9NH7Nd
SupkQsapFmg//Dpsh69ht2YZ92OH1Mjz1PgnoVLF1k+LYKJz/SiL
=gStn
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
