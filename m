Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1KXGUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:20:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54665 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1KXGT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:19:59 -0500
Date: Thu, 24 Nov 2011 17:19:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (pm
 tree related)
Message-Id: <20111124171949.994860621f4f83a650cf9b5b@canb.auug.org.au>
In-Reply-To: <201111150012.56306.rjw@sisk.pl>
References: <20111114142423.fe126b8c8cfd275d7dd138cc@canb.auug.org.au>
	<201111150012.56306.rjw@sisk.pl>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_17_19_49_+1100_fEdahr=PEGVkNnqC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_17_19_49_+1100_fEdahr=PEGVkNnqC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Tue, 15 Nov 2011 00:12:56 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> On Monday, November 14, 2011, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allnoconfig) failed like this:
> >=20
> > mm/oom_kill.c: In function 'select_bad_process':
> > mm/oom_kill.c:326:5: error: implicit declaration of function '__thaw_ta=
sk' [-Werror=3Dimplicit-function-declaration]
> >=20
> > Caused by commit 23527e313ca5 ("PM / Freezer: Fix fallout of thaw_proce=
ss()
> > -> __thaw_task() rename").  __thaw_task() is only declared id
> > CONFIG_FREEZER is set.  Commit 944e192db53c ("freezer: rename thaw_proc=
ess()
> > to __thaw_task() and simplify the implementation") removed the second
> > declaration of thaw_process() without replacing it ...
> >=20
> > I have added this patch for today:
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 14 Nov 2011 14:19:32 +1100
> > Subject: [PATCH] freezer: fix more fallout from the thaw_process rename
> >=20
> > Commit 944e192db53c "freezer: rename thaw_process() to __thaw_task()
> > and simplify the implementation" did not create a !CONFIG_FREEZER versi=
on
> > of __thaw_task().
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> I've applied your patch to linux-pm/pm-freezer and merged it into
> linux-pm/linux-next.
>=20
> Thanks,
> Rafael
>=20
> > ---
> >  include/linux/freezer.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> > index cc779bb..a9dccc6 100644
> > --- a/include/linux/freezer.h
> > +++ b/include/linux/freezer.h
> > @@ -166,6 +166,7 @@ static inline bool set_freezable_with_signal(void)
> >  #else /* !CONFIG_FREEZER */
> >  static inline bool frozen(struct task_struct *p) { return false; }
> >  static inline bool freezing(struct task_struct *p) { return false; }
> > +static inline void __thaw_task(struct task_struct *t) {}
> > =20
> >  static inline bool __refrigerator(bool check_kthr_stop) { return false=
; }
> >  static inline int freeze_processes(void) { return -ENOSYS; }
> >=20
>=20

This is back today, so I have applied the above patch again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Nov_2011_17_19_49_+1100_fEdahr=PEGVkNnqC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzeIFAAoJEECxmPOUX5FEiO8QAI7Y4bgXkb+0crZKIsE2uK65
s40/foD3LJF0SkvvqAerw2/Enh3xIEgOum7SeAAjjBrDK64SZPdl9FsmljYrEWu6
JLdDILttJLB50gmkNFE2XsUsVrMwXyXVCdriigNgwm/Q32kJ8OEdj+4SNLjXUPF3
0ves951zO4H/6+amff1RwYkXPeN2SxXJG3nSpAdIsCDuuW2fSnMU0bBTXp80NITE
40VPTJBwSCTuUL5cl/v+5ZNnODKPcGHuwYPUKrlQo3dOQG4f7uG8T1kJdk9Zcw/r
3dJJCH40AXez+BV6aAaeIJhiBiznO7vABAuq/jSk6WmaTnKYVL1E+gScVChgDn9k
01l9rFDBtU/4XrEvfr+i5DniRLtgEQkNG5PDQzUXRfhdps0xlyJJMl8JRRHvqtTa
M8vSdp78YIFf25kZXCCgLQopBPg28YL5qdCs9VHz0dJyg8AlponHK2EYUX+G7O3b
u0F1IGkeufghrA/JSPJmcTPSZnvJeTI5co/QX6zy5/eIuS+UE6lKQMvWEFA8q0Zx
VpPDrmEZu/xr1MEBiqVT4N3FglMOJb3QhO9WiT6Uvbk5q4T6qmQMDWFZ+yue0b//
HoqwTo0/5HSFuu6uInNER0sZCES3Bsd3WQ/IGFbnDik9nsycQAotUzmZTqEiavdb
ezKUvmNdAo03hPE3QkSi
=bNjt
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_17_19_49_+1100_fEdahr=PEGVkNnqC--
