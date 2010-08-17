Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0HQIkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:40:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50653 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab0HQIkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:40:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p/kiaromUc7NmfuT0HCr6qWo0dP+p4PxSnvSh0geN3qcvPFeit8aHgYIh+9wj8mxFM
         Cn6rGJloD8MvnFLbh539VeRRSFxBGSekqKCIFSOx+7eDtHUs+NqOp6zGXORl8AOUNN60
         wtrfa0VqfGc3bvGHtgujVMll0tbxHTNYU0uJ4=
Date: Tue, 17 Aug 2010 11:39:45 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
Message-ID: <20100817083945.GA12022@swordfish.minsk.epam.com>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
 <1281946970.1926.998.camel@laptop>
 <20100816133452.GS4879@redhat.com>
 <1281966418.1926.1421.camel@laptop>
 <20100816140829.GA5225@swordfish.minsk.epam.com>
 <20100817025954.GA12366@nowhere>
 <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (08/17/10 11:16), Yong Zhang wrote:
> On Tue, Aug 17, 2010 at 10:59 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > If preemption is disabled and you deal with the current cpu,
> > then please use __get_cpu_var, it makes the code more
> > readable:
> >
> >
> > void touch_softlockup_watchdog(void)
> > {
> > =A0 =A0 =A0 =A0preempt_disable();
> > =A0 =A0 =A0 =A0__(watchdog_touch_ts) =3D 0;
> > =A0 =A0 =A0 =A0preempt_enable();
> > }
>=20
> Why not use __raw_get_cpu_var() instead?
> You know adding preempt protection in touch_softlockup_watchdog()
> just suppress the warning. Am I missing something?
>=20

Sorry, my low level understanding of the __raw_get_cpu_var isn't very stron=
g.
I assume it uses current_thread_info()->cpu in some cases (right?) or=20
percpu_from_op.


Should it be
acpi_os_stall
	preepmt_disable
	touch_nmi_watchdog
		touch_softlockup_watchdog
	preempt_enable

?

	Sergey

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxqStEACgkQfKHnntdSXjQuAwP/UuUCYSQIo1iJVU2EWhsBHadY
6QYiwZVPycIqq4shadLAg4gFbfmZs/gpO25ZP1HPEsvl+/iyU7GzbXq50a+YZJRL
kkM8ez7oQ8OujuRezCB1Zu+jGkshG9wy/kcDtOjYnFhLUmca1n7X/J2UOiztKxV4
5c1XWThsGGXWd6YWdf8=
=1ve0
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
