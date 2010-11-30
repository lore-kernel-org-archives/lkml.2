Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0K3UBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:01:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41992 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0K3UBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:01:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xle8MCXSBVzkwIDu6HSrIgEDOldQULtLXUtldvOjga4I/nAHvqLGz9bYaH699PXXzn
         PeY0rwRO3z4OlkGyjIIekOtRwOlOw2SyYZUqyYrD4uFRkdPbgEGK6JiB6PEqA02r6QNn
         Y+svX13foZP0tLto1oR6CSEEOmxbGLGGlNqSM=
Date: Tue, 30 Nov 2010 15:01:11 -0500
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: tmhikaru@gmail.com, Damien Wyart <damien.wyart@free.fr>,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101130200110.GA11265@roll>
References: <20101110034507.GV8332@bombadil.infradead.org> <1289390424.2191.98.camel@laptop> <20101114051406.GA2050@roll> <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop> <1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette> <1291030726.32004.4.camel@laptop> <20101129194041.GA8280@roll> <1291071677.32004.527.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <1291071677.32004.527.camel@laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 30, 2010 at 12:01:17AM +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-29 at 14:40 -0500, tmhikaru@gmail.com wrote:
> > On Mon, Nov 29, 2010 at 12:38:46PM +0100, Peter Zijlstra wrote:
> > > On Sun, 2010-11-28 at 12:40 +0100, Damien Wyart wrote:
> > > > Hi,
> > > >=20
> > > > * Peter Zijlstra <peterz@infradead.org> [2010-11-27 21:15]:
> > > > > How does this work for you? Its hideous but lets start simple.
> > > > > [...]
> > > >=20
> > > > Doesn't give wrong numbers like initial bug and tentative patches, =
but
> > > > feels a bit too slow when numbers go up and down. Correct values are
> > > > reached when waiting long enough, but it feels slow.
> > > >=20
> > > > As I've tested many combinations, maybe this is an impression becau=
se
> > > > I do not remember about "normal" delays for the load to rise and fa=
ll,
> > > > but this still feels slow.
> > >=20
> > > You can test this by either booting with nohz=3Doff, or builting with
> > > CONFIG_NO_HZ=3Dn and then comparing the result, something like
> > >=20
> > > make O=3Ddefconfig clean; while sleep 10; do uptime >> load.log; done=
 &
> > > make -j32 O=3Ddefconfig; kill %1
> > >=20
> > > And comparing the curves between the NO_HZ and !NO_HZ kernels.
> > >=20
> > > I'll try and make the patch less hideous ;-)
> >=20
> > I've tested this patch on my own use case, and it seems to work for the=
 most
> > part - it's still not settling as low as the previous implementation us=
ed
> > to, nor is it settling as low as CONFIG_NO_HZ=3DN (that is to say, 0.00=
 across
> > the board when not being used) however, this is definitely an improveme=
nt:
> >=20
> > 14:26:04 up  9:08,  5 users,  load average: 0.05, 0.01, 0.00
> >=20
> > This is the result of running uptime on a checked out version of
> > [74f5187ac873042f502227701ed1727e7c5fbfa9] sched: Cure load average vs =
NO_HZ woes
> >=20
> > with the patch applied, starting X, and simply letting the machine sit =
idle
> > for nine hours. For the brief period I spent watching it after boot, it
> > quickly began settling down to a reasonable value, I only let it sit id=
le
> > this long to verify the loadavg was consistently low. (the loadavg was
> > consistently erratic, anywhere from 0.6 to 1.2 with the machine idle wi=
thout
> > this patch)
>=20
> Ok, that's good testing.. so its still not quite the same as NO_HZ=3Dn,
> how about this one?
>=20
> (it seems to drop down to 0.00 if I wait a few minutes with top -d5)


I haven't had time to test your further patches but THIS works!

14:57:03 up 14:01,  4 users,  load average: 0.00, 0.00, 0.00

Load seems to finally be accurate on my machine compared to processes
running/whatever else usage. This is again testing vs the original commit
that caused the problems for me:

[74f5187ac873042f502227701ed1727e7c5fbfa9] sched: Cure load average vs NO_H=
Z woes

so I know I'm testing apples to apples here.


As time permits I'll test the later replies you made to yourself.

Thank you,
Tim McGrath

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTPVYBpEncCrqzVruAQJItAgAlkEhMboh0zSGF8DiJGHWxmppMK04PtyM
5tUZYW7lKrzPW+4KT2WZLd+E77c4jAGrRKSIOSd5uUprx71kGZOZ7kM3FrJevASj
GsiGn6m5taSk2bHAbtgn03GFe/fSTLwOVQdMDv58J/qAott6qBblPh1j7rgkgZ8T
i9WX4GzjSlT2dewF7V61gbPFz7WHHulraCg2Fyx0RKJz827Z4042WI2ghwzuxsWe
DZnLLUtka6ZYGxnlcfp0Q0NVeCHSylF9KCnBSDN8kMN7bWh9SwSVQ9Dq0xl1LlCX
B1BGnc0HOSp+uQHRYSD5wmrjg2OHEpK91UiNsZ31Z+41SvtVWbzkFQ==
=E9JV
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
