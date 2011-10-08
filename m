Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1JHLPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 07:15:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab1JHLPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 07:15:05 -0400
Date: Sat, 8 Oct 2011 22:14:39 +1100
From: NeilBrown <neilb@suse.de>
To: markgross@thegnar.org
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111008221439.48f30263@notabene.brown>
In-Reply-To: <20111002164456.GC14312@mgross-G62>
References: <20111002164456.GC14312@mgross-G62>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kFDK2IVHziY0EseCoZ13wpE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kFDK2IVHziY0EseCoZ13wpE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Oct 2011 09:44:56 -0700 mark gross <markgross@thegnar.org> wrote:

> resending to wider list for discussion
> ----- Forwarded message from mark gross <markgross@thengar.org> -----
>=20
> Subject: [RFC] wake up notifications and suspend blocking (aka more wakel=
ock stuff)
> Date: Tue, 20 Sep 2011 13:33:05 -0700
> From: mark gross <markgross@thengar.org>
> To: linux-pm@lists.linux-foundation.org
> Reply-To: markgross@thegnar.org
> Cc: arve@android.com, markgross@thegnar.org, Alan Stern <stern@rowland.ha=
rvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysock=
i" <rjw@sisk.pl>
>=20
> The following patch set implement an (untested) solution to the
> following problems.
>=20
> 1) a method for making a system unable to suspend for critical sections
> of time.

We already have this.  A properly requested suspend (following wakeup_count
protocol) is unable to complete between wakeup_source_activate() and
wake_source_deactivate() - these delimit the critical sections.

What more than this do you need?

If user-space wants to prevent suspend, it just needs some sort of protocol
for talking to the user-space process which follows the correct protocol to
initiate suspend.  That isn't a kernel problem.

>=20
> 2) providing a race free method for the acknowledgment of wake event
> processing before re-entry into suspend can happen.

Again, this is a user-space problem.  It is user-space which requests
suspend.  It shouldn't request it until it has checked that there are no wa=
ke
events that need processing - and should use the wakeup_count protocol to
avoid races with wakeup events happening after it has checked.

i.e. there is no kernel-space problem to solve here (except for possible
bugs).

NeilBrown


--Sig_/kFDK2IVHziY0EseCoZ13wpE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpAwqTnsnt1WYoG5AQLZ0xAAjUCnsIWuTviahIItYAJAgMZ5VbopOoyH
h1eOUEG+68gPHkSYOWQdbmXYHdCTndPDeDZqgkGUVhdl7UJV5wEpgiEUw9ldQbpj
kKeETozRJjz86w4/pJ0DYYop8NhPu7Iv7oFm5CBpfolazyPTEnxlIhArF/sbRSFP
XoWtdH//1BRsPz3LsVS8nLwH60NSUMZ3Pkvnq6GJqGbb060P169hi0CJX5sDAPiq
aof5lfJlRJhrlHwMjRkmZgN6EixE+N0vT/o2TqRRAW/RStYT1JVAqfgdymi9KxQW
ivZt/lemV3Yb9lx0gjnh3jtyzokrW2s6z6rjisFaXHnjdsm2y4fOoruCeeYllP8w
g/xBK//bXZkrYkrYmWQz99BHXtk8gutslmE/KxDAPCifCQyVqK/YfE+3d2cArP5O
5gCSP4Voufwd4sCAZMWwhGQGyqWVlEBtwAPiIoVTJBF5NVvlC+DpoE+NcqJbp8Tz
VcZ1obt2jBHWZt/TNrsvC9o+1VjGd0VCHWQzbDX64+mOZcs8+JS21LWh9ucMxtKV
+ttjhPYGdiHcRIFw5PxIKdOgy7Zji4z5fG5n4bw4dJEcTT8AcZnLUFTjOxoLn7Qg
/BMHi3l9K+/A2eF7Fc93Kr8LxfCgDQ/YWNDMIYIDCKM8yZ2gORvofaB9CyM6R5uD
T+4nj37hxNc=
=9VbO
-----END PGP SIGNATURE-----

--Sig_/kFDK2IVHziY0EseCoZ13wpE--
