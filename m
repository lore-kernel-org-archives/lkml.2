Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab0LBKRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 05:17:08 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65435 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0LBKRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 05:17:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f40bLvSt3O839oHrrbAgWafHejvYYyou0SuU6HXKUzexXfvNIgL88NO7pX4Fc3T+3V
         m3K14TnE1FRRP5bZAn/98YYOSOqfkQ/yexDkAaVcXEnNNhCjnZlUC6BUvNbq5fo+Lput
         O3vLyeu0FwdQqryqvswM42uZvM461dBp6Oong=
Date: Thu, 2 Dec 2010 05:16:58 -0500
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Damien Wyart <damien.wyart@free.fr>,
        Venkatesh Pallipadi <venki@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
        tmhikaru@gmail.com
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101202101658.GA5621@roll>
References: <20101114051406.GA2050@roll> <20101125133106.GA12914@brouette> <1290693807.2145.36.camel@laptop> <1290888920.32004.1.camel@laptop> <20101128114027.GA2745@brouette> <1291030726.32004.4.camel@laptop> <20101129194041.GA8280@roll> <1291071677.32004.527.camel@laptop> <1291129145.32004.874.camel@laptop> <20101201212738.GA16944@roll>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <20101201212738.GA16944@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 01, 2010 at 04:27:38PM -0500, tmhikaru@gmail.com wrote:
> On Tue, Nov 30, 2010 at 03:59:05PM +0100, Peter Zijlstra wrote:
> > On Tue, 2010-11-30 at 00:01 +0100, Peter Zijlstra wrote:
> > >=20
> > > Ok, that's good testing.. so its still not quite the same as NO_HZ=3D=
n,
> > > how about this one?
> > >=20
> > > (it seems to drop down to 0.00 if I wait a few minutes with top -d5)
> >=20
> > OK, so here's a less crufty patch that gets the same result on my
> > machine, load drops down to 0.00 after a while.
> >=20
> > It seems a bit slower to reach 0.00, but that could be because I
> > actually changed the load computation for NO_HZ=3Dn as well, I added a
> > rounding factor in calc_load(), we no longer truncate the division.
> >=20
> > If people want to compare, simply remove the third line from
> > calc_load(): load +=3D 1UL << (FSHIFT - 1), to restore the old behaviou=
r.
>=20
> For some bizzare reason, this version has a small but noticable amount of
> jitter and never really seems to hit 0.00 on my machine, tends to jump
> around at low values between 0.03 to 0.08 on a routine basis:
>=20
> 16:20:42 up 16:31,  4 users,  load average: 0.00, 0.01, 0.05
>=20
> the jitter seems to have no visible reason for it happening; with no
> networking, disk access or a process waking up and demanding attention fr=
om
> the cpu, it goes back up.
>=20
> Mind this is obviously NOT as horrible as it was originally, but I'd like=
 to
> find out why it's acting so differently.
>=20
> I'm going to try this variant again with that line you were talking about
> disabled and see if it reacts differently. I get the feeling if it's the
> rounding factor - since you say that was changed for BOTH nohz=3Dy and n,=
 that
> it's not really a problem in the first place, and likely is very low load
> that wasn't being accurately reported before.

Indeed, this seems to be the case:

04:50:14 up  5:45,  5 users,  load average: 0.00, 0.00, 0.00

the average seems to not be jittery, or at least noticably, and reacts as I
have expected it to in the past with that single line disabled; Since you
have said that this change would affect all load calculations I have not
tested how this patch with the line enabled/disabled reacts with nohz=3Dn,
please let me know if you would like me to test that condition anyway.

Personally since it changes the previous behavior of the load calculation
I'd prefer that the rounding not be done.

Tim McGrath
--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTPdyGpEncCrqzVruAQLVMgf8CLo/zTMDQUjrm9G83ot+Qy5InRORT8Zg
KFq1GJIJy8EHT1ozn5xy/9fkV8DgdAmdfKtIlBLiDbBZ0G2z8eVlihTQp5Bu/JtQ
806a0is84uGjgfxOXEDOkDmu7JEFXsCjAoqT6kp84Zq5hZ5KQggAHErG6L8VBcfd
shdJbb2hwFGXHsF3Dzn6ItoWIiOvbf3TLLgzIqomxEijvmrRkpKLd1bVg6/YBPHS
UrKnGIQ+Jx+AiP7DOPSJx/C4AaFO8aI1idTpk+U7RioZ3tF7MH2RagQWQixFmV2l
tYBiq/pnHn9D0Q5JroopPL7z9NUnnEHne8ijWjP76mUXSmonRhIoeQ==
=+xUM
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
