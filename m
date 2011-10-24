Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1JXBun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 21:50:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1JXBum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 21:50:42 -0400
Date: Mon, 24 Oct 2011 12:50:34 +1100
From: NeilBrown <neilb@suse.de>
To: markgross@thegnar.org
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111024125034.71993780@notabene.brown>
In-Reply-To: <20111024011804.GB12215@mgross-G62>
References: <20111016092556.07d6e415@notabene.brown>
	<Pine.LNX.4.44L0.1110152136460.19724-100000@netrider.rowland.org>
	<20111017083717.0bd5626c@notabene.brown>
	<20111024011804.GB12215@mgross-G62>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VSk.TKBfakxTIqnamWLW=T8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VSk.TKBfakxTIqnamWLW=T8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Oct 2011 18:18:04 -0700 mark gross <markgross@thegnar.org> wrote:

> Sorry for going AWOL on this thread.  I had some biz travel and fires to
> fight.

:-)  Life happens.  Welcome back.


> > So it is a good example and highlights the difficulty of defining exact=
ly
> > what a wake-up event it, and of what it means to be "visible".
> >=20
> > I think it still fits in your rephrasing of my question which - if I re=
phrase
> > it as a requirement - is roughly,
> >=20
> >   A wakeup-event that needs to be handled by user-space must be visible=
 to
> >   user-space before the driver deactivates the wakeup_source.
> >=20
> > A requirement which, in this case, means the driver needs to hold  the
> > wakeup_source for an extended time using a timeout, just as you say.
>=20
> Timeout?  why can't we define a proper notification handshake for such
> things?  Timeouts are never right IMO.
>=20

I thought that before, but I have come around to the opposite way of thinki=
ng
thanks to some instructive examples from Alan and Rafael.

Some things are simply not visible to the OS.  We can expect them to be
happening but we cannot be sure and there is no clear signal that they aren=
't
actually happening.  So we need a timeout.

- OS cannot detect state of user's brain, so uses a time-out to blank the
  screen after a period of inactivity.
- USB cannot (I think) know which USB device triggered a wake-from-suspend,
  and in any case cannot directly ask the device why it woke from suspend.
  It has to wait for the device to tell it (in response to a regular
  'interrupt' poll I assume - but it isn't guaranteed to be reported on the
  first poll) - or timeout and give up waiting.
- A wake-on-Lan packet may wake a suspend up, but not be further visible to
  the OS.  And even if it was, the 'SYN' packet or maybe 'ARP' packet that
  might be expected to follow it is invisible until it actually arrives, and
  it may not ever come.  So we need a timeout to give up waiting after a
  while.

When-ever we are dealing with external events we need timeouts - and
wake-from-suspend is primarily about external events.

So *somewhere* in the handling of wakeup events there must be timeouts.
Whether that should be explicit in the wakeup-source is possibly a separate
question.  Maybe you could argue that the low level device driver must have
timeouts anyway, so it should use them to explicitly deactivate the source
rather than the source having it's own timeout.
I'm not sure that argument would work though it might.
But saying "Timeouts are never right" cannot work - unless you mean it in a
much more restricted sense than I think you mean it.

(I can agree that it is *best* if timeouts never fire - if direct action
causes the wakeup-source to deactivate long before the timeout.  I agree th=
at
is the best case and probably should be the common case, but I cannot see h=
ow
it can be the only case).

Thanks,
NeilBrown

--Sig_/VSk.TKBfakxTIqnamWLW=T8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqTEajnsnt1WYoG5AQJg/g/+JrFTPYEui6r2RW/90xhOOhAG48qThU8K
PVtxe7A8N4N/YZElRzxXw6RNJ5BgbFbT002VilfqfGpJmDm0jbksbS5MB3cdTJ0h
Vhbt2wKIq2QLqiJ4SGKn5mLWbNmjtLqewD3Tl9K2f+VFvTCtC44McxgJrHTa/Q1w
BFbomv78j2pXnYqnYYvNPTPdlm16Xtah+y4rpsqw8ipO7iojcb1DraDoxUXYo1a2
9KpfdZe9I3ClXbaekLDxlr34qZoizuEpBm8kvLPMuB4mhLIlga6plDZMCWOv7ghB
TXIGK4RcIqmdrkaRNrSLvjCageOxE0EaElNmT2HkQp1V/1sQhQ59hQkb7OyED2oz
sJG0TDOKaMHZ+5V9CdRowM5ubJQHnJibyo67E9obP/suVSgt7d/gQX+qPmZLluhC
hOMKp+VA+vbTGW16Mrsgc6KzNvZcHN0qiAJMtN2eKh7TUiPHaudlwIJfjZNXOky5
NdD91wk1gkk/rn7fTaqgsgOj43xDFmFPVEieJyu69nkgN+cexiRATwlHWH7uEp76
7QpV4jJHhgV2hoXq2tXyH0IE1TkOZPgOj/B0utDjAVVixvpyB9dDqoFAENw3G9jd
npSP/wYluAVGkpChAbpPnD7oBDJGYA1CtHi1mT39kz6rdlJ+PIH3XzCx4wobhm92
T7+MUZ7rTXw=
=54Wu
-----END PGP SIGNATURE-----

--Sig_/VSk.TKBfakxTIqnamWLW=T8--
