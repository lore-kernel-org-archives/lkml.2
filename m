Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2IHTI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 15:08:58 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:38728 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754530Ab2IHTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 15:08:54 -0400
Date: Sat, 8 Sep 2012 22:04:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-serial@vger.kernel.org, Sourav Poddar <sourav.poddar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        alan@linux.intel.com
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Message-ID: <20120908190423.GA14771@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120906122948.GC29202@arwen.pp.htv.fi>
 <1346935540-1792-1-git-send-email-balbi@ti.com>
 <87harahiv6.fsf@deeprootsystems.com>
 <20120907054932.GB3136@arwen.pp.htv.fi>
 <87oblhmu6g.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <87oblhmu6g.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 07, 2012 at 01:53:11PM -0700, Kevin Hilman wrote:
> Felipe Balbi <balbi@ti.com> writes:
>=20
> > Hi,
> >
> > On Thu, Sep 06, 2012 at 03:44:13PM -0700, Kevin Hilman wrote:
> >> Felipe Balbi <balbi@ti.com> writes:
> >>=20
> >> > Hi guys,
> >> >
> >> > here's v4 of the omap uart patchset. No changes other than a rebase =
on top of
> >> > Greg's tty-next branch and Tony's Acked-by being added to a couple p=
atches
> >> >
> >> > Note: I'm resending the series with Vikram's Software Flow Control f=
ix anyway
> >> > as it can just be ignored if it's decided it needs to go into this m=
erge
> >> > window.
> >>=20
> >> Sorry to be late to the party... just getting back from some time off.
> >>=20
> >> I'm assuming that this was not tested with PM, so decided I better do =
it
> >
> > you assumed wrong. See the previous versions of the series and you'll
> > see I mention all the basic pm testing I did.
>=20
> My apologies for not reading the previous versions.  I don't think it's
> unusual that a reviewer should expect everything he to know about a
> series (including how it was tested) is in the cover letter or in the
> changelogs of the latest series.  I don't expect to have to look through

you've got a point there. My bad, should've kept series history on all
revisions.

> all the previous versions for this kind of info.  Since I wasn't around
> to review/test the earlier versions, I just looked at the latest (v4)
> and didn't see any mention of testing of any sort in the cover letter.

Well, fair enough. Maybe I wasn't too verbose, but here's what I did on
panda:

=2E check that console still works
=2E check that IRQs increase as I type on console
=2E check that pm_runtime suspend callback is called after 1 second of
	inactivity (with printk)
=2E check that device resumes properly when I type on console again
=2E enable UART wakeup (through sysfs) and 'echo mem > /sys/power/state'
	then check that I can wakeup from suspend and check that all
	powerdomains actually reached low power state

> Looking back at the previous cover letters, I don't see any description
> of the PM testing either.  I only see it was tested on pandaboard.

Yeah, initially I wasn't testing PM because UART wakeup was known to be
broken, but then I decided to test and sent it as a reply to cover
letter v2, then I forgot to keep the history on v3 and v4. My bad.

> Since mainline doesn't have full PM support for OMAP4, testing on panda
> doesn't really test UART PM at all.

Fair enough. What's missing for omap4 panda ? I could reach suspend2ram
with echo mem > /sys/power/state and wakeup from it.

> Could you please point me to the descriptions in earlier mails of how
> you did PM testing, and on what platforms?

Though not on a cover letter, this is how I was testing from v2 and
onwards:

http://marc.info/?l=3Dlinux-omap&m=3D134555434407362&w=3D2

> In addition, IMO, if this was only tested on Panda (as suggested by
> earlier cover letters), it really should not have been merged until it
> got some broader testing.

Shubhro's got his Tested-by tag. I believe he tested on beagleboard and
omap4sdp. Shubhro, can you confirm which platforms you tested the UART
patches ? cheers

> >> myself seeing that Greg is has already merge it.  To test, I merged
> >> Greg's tty-next branch with v3.6-rc4 and did some PM testing.
> >>=20
> >> The bad news is that it doesn't even compile (see reply to [PATCH v4
> >> 20/21]). =20
> >
> > yeah, that was an automerge issue when rebasing on greg's tty-next
> > branch, plus me assuming omap serial was already enabled on my .config
> > and not checking the compile output. Sent a patch now.
>=20
> As I reported in my reply to [PATCH v4 20/21], that patch also had
> another problem where it introduced a new (but unused) field.  Maybe
> another rebase problem?  I see the same problem in v3 and v4.

I'll check it out and make sure to delete any such unused fields. Thanks

> >> Also, there is a big WARNING on boot[1], which seems to be triggered by
> >> a new check added for v3.6-rc3[2].  This appears to be introduced by
> >> $SUBJECT series, because I don't see it on vanilla v3.6-rc4.
>=20
> [...]
>=20
> > This doesn't seem to be caused by $SUBJECT at all. See that we are
> > calling uart_add_one_port() which will call tty_port_register_device()
> > which, in turn, will call tty_port_link_device() and that will set
> > driver->ports[index] correctly.
> >
> > Have you checked if this doesn't happen without my series before waving
> > your blame hammer ? FWIW, that part of the code wasn't change by
> > $SUBJECT at all.
>=20
> Whoa.  This was only test report.  No need to get personal.  All I said
> is that it "seemed" to introduced by $SUBJECT series.  Hardly waiving
> "blame hammer."

fair enough.

> And yes, I did check without your series.  As I reported above, the

What about v3.6-rc4 + the patch which added the warning ? :-)

> warning didn't exist with v3.6-rc4, and it did with yesterday's tty-next
> branch.  The WARNING pointed a finger at ttyO (omap-serial) so I assumed
> it was in $SUBJECT series.
>=20
> Testing with todays tty-next, the problem is gone.  The patch
> 'tty_register_device_attr updated for tty-next'[1] seems to have made
> the problem go away.  So it's now clear that it wasn't introduced by
> $SUBJECT series.   My bad.

Thankfully...

> Yesterday, it wasn't that obvious, so I made an assumption in order to
> report a problem uncovered in my testing in the hopes that it would be
> helpful to you in fixing a potential problem. My assumption was wrong, I
> was wrong.  I'm wrong a lot, and I'm OK with that. The bug was
> elsewhere, and is already fixed.
>
> My apologies if it seemed like I was blaming you.

I'm the one who owes you an apology for misunderstanding your bug
report. I'm sorry.

--=20
balbi

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQS5a3AAoJEIaOsuA1yqRExncQAJLpcC8IyzSD9e8eosXgO2Vq
54JwUcR3hveqeDcC5Yo7Tq7g8AZUvGsEDd6iE6nKdBPc+GJt1zc3LMtUzQf7pufx
AA5k6C29nEwo1oN8dKCA1Ma3nkmEZVUpDT9x94jEFLEtqMYMcptniH0r8uv5Qz/f
fxpxb56dbttIERB6tkPAVqQeb4EM+3s2x6/CtFr79P9oDJxQ+iDDYViVK2jy2JJ0
S0++9LDs4VVOeLQSaCXPuONAha0IHQio80Wklp/poNTYgitK8XsVU0Vr4wvqmCjV
l7BzLBDvv+ipX/qagK1OuG9e4AC3tij91pFcor54AhJj3/bA3eWi603TaeEsy+VM
esy390WvuOsS3RY+D+g8cv8wUZDjc7oEmdbxjudG7/fNBzU/gwMBWKvGwxYSyLeQ
RjfUhhBysOfyXfPPRI2wwhjkpmGawxiKTKoJB74kJA42ImXkGCiFx9HOdpQKNiZZ
9KMNajS5RdY7JjsM2RiCAzj6+PeU/gYAGhIiihJaOF2jsm6UbHxvLBKOutoyz6Jj
zVr7m5LbimPcmobecDmmof6d8Q0i6D3Cx/TgDXlftotkg63581xrR+n2mPvKhCbO
NUZOpErAeOagBr5l4kY6+NGe9OrMd/jVygkzV01ZqAy7OgvDvwhHwzNJZirp6GXm
YJbmPcDKkE1bZw67n2S1
=1RBi
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
