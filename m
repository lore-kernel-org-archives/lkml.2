Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0KCQiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:38:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53475 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0KCQiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cxr3DKa3XNqBixF2HykGlTXwEL8mgbJeNokpcfw80RxK3PALUvFv59U8obkbfD5DsF
         5vLklc5NcsDbcl7L+VOkr4y4lO2k4fS4mKYMA/uJcq0n0kHH687bK0n/YJaZx6LV6/9C
         eON1JWaql8bWjgozV0Dq+Ee1bldE8s15MYZNA=
Date: Wed, 3 Nov 2010 18:38:16 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] posix-cpu-timers: rcu_read_lock/unlock protect
 find_task_by_vpid call
Message-ID: <20101103163816.GC30053@swordfish.minsk.epam.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com>
 <alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6>
 <20101102160223.GC5964@swordfish.minsk.epam.com>
 <alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6>
 <20101102183308.GA17720@redhat.com>
 <20101103105832.GA30053@swordfish.minsk.epam.com>
 <20101103124835.GA604@redhat.com>
 <20101103161059.GA13530@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <20101103161059.GA13530@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (11/03/10 17:10), Oleg Nesterov wrote:
> On 11/03, Oleg Nesterov wrote:
> >
> > Sergey, Thomas, please wait a bit.
> >
> > Yes, I believe this patch is fine by itself. But looking into
> > posix-cpu-timers.c again, I suspect that those "other problems
> > with de_thread" I already mentioned are much more serious and
> > need the urgent fix.
>=20
> Yes. I'll send the patch tomorrow.
>=20
>=20
> However, my initial thinking was wrong, that bug is orthogonal
> to this patch.
>=20
> Sergey, how much will you hate me if I ask you to re-send it again?
>

Oleg, not a problem at all. Which one should I resend?

#  desc.
1) added rcu_read_lock/unlock
2) removed tasklist_lock
3) added has_group_leader_pid


	Sergey

=20
>=20
> > > On (11/02/10 19:33), Oleg Nesterov wrote:
> > > > > On Tue, 2 Nov 2010, Sergey Senozhatsky wrote:
> > > > >
> > > > > > > We can remove the tasklist_lock while at it. rcu_read_lock is=
 enough.
> > > > > > >
> > > >
> > > > Yes, I believe posix-cpu-timers.c shouldn't use tasklist at all,
> > > > but it is not trivial to change this code.
> > > >
> > > >[..]
> > > >
> > > > I think this change is fine, but please note that thread_group_lead=
er()
> > > > check is not relaible without tasklist. If we race with de_thread()
> > > > find_task_by_vpid() can find the new leader before it updates its
> > > > ->group_leader. IOW, posix_cpu_timer_create() can fail when it shou=
ldn't.
> > > >
> > > > Not that I think this really matters, posix_cpu_timer_create() has
> > > > other problems with de_thread(). But perhaps it makes sense to
> > > > change posix_cpu_timer_create() to use has_group_leader_pid() inste=
ad,
> > > > just to make this code not look racy and avoid adding new problems.
> > > >
> > > > The real fix, I think, should change cpu_timer_list to use
> > > > struct pid* instead of task_struct.
> > > >
> > >
> > > Hello,
> > > Using has_group_leader_pid instead of thread_group_leader, when taskl=
ist_lock
> > > is not aquired (check_clock and posix_cpu_timer_create).
>=20
> This doesn't look like a valid changelog ;) I'd suggest you to write
> the new one without quoting old emails. It should explain that a)
> tasklist_lock is not enough for find_vpid() and b) it is not needed.
>=20
> Also, you forgot to add your signed-of-by.
>=20
> Otherwise,
>=20
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
>=20

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAkzRj/gACgkQfKHnntdSXjRnrQQAhRhjsEWvL6IrZ++bfSoWdpeF
KplhaX338qI1BgQUJ9hOTk1sXUoo/CFJQGZLHj9ITb69lpW+hMsZMB5mqbJWINiK
NI9xYG6fC1oqEPszJodD3aXCCCVHNK1PA/t9KF0q20SaiN7O1wDyo++9WErflYVt
M3tOLzgJakj/8ZqWUqU=
=Se+G
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
