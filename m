Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab1JNVHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:07:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab1JNVHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:07:32 -0400
Date: Sat, 15 Oct 2011 08:07:18 +1100
From: NeilBrown <neilb@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111015080718.01aef515@notabene.brown>
In-Reply-To: <Pine.LNX.4.44L0.1110141156040.2036-100000@iolanthe.rowland.org>
References: <20111014165212.7929243c@notabene.brown>
	<Pine.LNX.4.44L0.1110141156040.2036-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jx90OYfelV+OPPjo1c/3rFS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Jx90OYfelV+OPPjo1c/3rFS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Oct 2011 12:00:59 -0400 (EDT) Alan Stern
<stern@rowland.harvard.edu> wrote:

> On Fri, 14 Oct 2011, NeilBrown wrote:
>=20
> > Hi Rafael,
> >=20
> >  What do you mean by "too complicated to use in practice"?  What is you
> >  measure for complexity?
> >  Using suspend in a race-free way is certainly less complex than - for
> >  example - configuring bluetooth.
> >  And in what way is it "inadequate for other reasons"? What reasons?
> >=20
> >=20
> >  The only sane way to handle suspend is for any (suitably privileged) p=
rocess
> >  to be able to request that suspend doesn't happen, and then for one pr=
ocess
> >  to initiate suspend when no-one is blocking it.
>=20
> One of the things Rafael didn't mention is that sometimes a kernel=20
> driver needs to prevent the system from suspending.  This happens when=20
> recharging over a USB connection.
>=20
> There's no simple way for such a driver to communicate with a power
> daemon.  The driver has to use something like the wakeup mechanism --=20
> but currently that mechanism is optional.
>=20
> Alan Stern

Certainly I don't expect a kernel driver to communicate directly with a
user-space daemon.  It communicates indirectly through the wakeup_source
mechanism.
If user-space wants to block suspend, it talks to the suspend daemon (power
manager) some how (dbus, lock files, sockets, signals, whatever).
If the kernel wants to block suspend, it activates a wakeup_source (aka
caffeine source) which the suspend daemon notices via /sys/power/wakeup_cou=
nt.

But you say this wakeup mechanism is optional .... I don't see that.

It is implemented in drivers/base/power/wakeup.c which is included in the
kernel if CONFIG_PM_SLEEP which is defined as

config PM_SLEEP
	def_bool y
	depends on SUSPEND || HIBERNATE_CALLBACKS

which seems to mean "enable this unless we don't have suspend and we don't
have hibernate".

So it seems that the only time we don't have the wakeup mechanism, we also
have no risk of ever going to sleep.

What exactly where you saying was "optional"?? I don't understand.

NeilBrown

--Sig_/Jx90OYfelV+OPPjo1c/3rFS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpikhjnsnt1WYoG5AQI3zQ//VZieG1Zjw645KUWgsClYywMjUqP39CdY
Y8PgQ1fujdAV4Tn4DahvpKZ9n4j93ugW/Fftqt6843ZecLt2rOhJ33jq7HmFgl1T
3eshZzapCAipb88/Ip51PgggGlZmt9miMcpfAy5C2ple/RBGAWmcCd74+81wd33o
FI5lp0X+TjGbsQbOy3GaTY14MdSnOgfUH/t20tTc5GCloNGfH0sVkf0O7wsEyMjj
bDbu9AFDnuJxFabzWKwyjB62lL4lgZ9YIQYGZM77kqJUnJsCddAltgNPerj2m65M
XF6CuHaiN7zPpn5C9WqRDK5c8VUVd3plYDJO0SpPOMloBlnn+KWWV7kFOZ/PMTbr
XqfHbjhEU4++fC6JG5/ynbk6qO2NcWb6qkYKmwE3qqnGba5FRZg6fth4e+RioFuP
57A3/UB/epBJ39wJmaOk5r/Je2OJmXTSowf8DZBVKhRHqlNHne7F+M+QW/e6RJfI
yIFRJUfdboqZYvWrrkijdGzDhTVwawAydtJX5MH1omIxYDVZcdpMNyLGSj0Asbya
uI8TytTcombjUEhFEj34jxS7M1Jb6ZJzEk8qQpPQMENKyJ5c4LXOBWTfe1ETFN+P
wTmx/v2TMQlV+pJQCbVib73GVuOTvLyy2ZDMm+2hBKs2oOXOzIFgK3twy3Cf9YlP
zm5A9fBGSeA=
=XyXm
-----END PGP SIGNATURE-----

--Sig_/Jx90OYfelV+OPPjo1c/3rFS--
