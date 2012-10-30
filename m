Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2J3LF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:05:29 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:46449 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab2J3LF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:05:28 -0400
Date: Tue, 30 Oct 2012 11:05:20 +0000
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 3.7-rc3
Message-ID: <20121030110520.GH5042@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com>
 <26004880.qboZkUVCy9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cW+P/jduATWpL925"
Content-Disposition: inline
In-Reply-To: <26004880.qboZkUVCy9@vostro.rjw.lan>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cW+P/jduATWpL925
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 30, 2012 at 01:10:32AM +0100, Rafael J. Wysocki wrote:
> On Sunday, October 28, 2012 12:59:49 PM Linus Torvalds wrote:
> > It's been a week, time for -rc3!
> > 
> > Nothing particularly stands out here. Lots of small fixes, exemplified
> > by the series of memory leak fixes in usb serial drivers. Just a lot
> > of random stuff..
> > 
> > Most of it is drivers (all over: drm, wireless, staging, usb, sound),
> > but there's a few filesystem updates (nfs, btrfs, ext4), arch updates
> > (arm, x86 and m68k) and just random stuff. Shortlog appended.
> 
> Unfortunately, s2disk is broken with this one and previous -rc.  In the
> majority of cases it just hangs the machine during hibernation, although
> sometimes it returns to user space reporting freezing problems, suspicions
> RCU usage and similar stuff, pretty much without any useful debug information.
> 
> I'm quite confident that v3.6 was OK (and -stable based on that too), so
> it most likely is a recent regression.  The in-kernel hibernation
> (ie. "echo disk > /sys/power/state") works no problem.  So does suspend to
> RAM on my test boxes.
> 
> So far I have been able to reproduce this 100% of the time on two machines
> with Intel CPUs and graphics driven by i915.  I _suspect_ that this may be
> related to VT switching, because s2disk does some ugly things in that area
> which are not done by the in-kernel code.  Dunno.

   I've had this symptom on my laptop (Thinkpad Edge 13, Intel
graphics & CPU; I can get details when I get back home in about 8
hours), but only with 3.7-rc2. It was definitely working in 3.6, and
seems to be OK in 3.7-rc3, although I've only tried two cycles of that
last night.

   When I did suspend to disk, I get a blank screen (but clearly with
backlight still on), and a blinking text-mode cursor in the top left.
I left it for half an hour once, and nothing changed, so I'm fairly
sure it was properly hung. I've not seen it return to user space with
errors at all -- just the hang.

> Anyway, it looks like nothing short of bisection is going to help debug this,
> but I'm afraid I won't have the time to bisect within the next two weeks, so if
> anyone can reproduce this issue and will be able to bisect it, please help
> (openSUSE/Tumbleweed users anyone?).

   I can try to bisect the 3.6 -> 3.7-rc2 failure, if that helps? But
as I said, I've got it working on -rc3, so I may not have the same
problem.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- UNIX: Spanish manufacturer of fire extinguishers. ---        

--cW+P/jduATWpL925
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUI+0b79z9OVl50rAAQJmkQ//aS4J+v5dx7uI/rwZdthqxRqzxYGlpBaa
0XbvI0RCwglKIwd16W04MwUNB7yy3But7gDDwSZFKKJciBS/530VYLbwFDDLP2H6
/IUXzglsaNAXLSkzK6zEqwPDti5JBeq5rh+izmukQHAuhVU4kSOqUnMwB2xRWbsn
3zbtqsaj8VCL2N+OHF7QC6aJCp9uZeepdyGlboACPWz/PAp2oFq0yZmhmlnrpASf
8755nTM14VnMpuiq/mrgaSvf2kJ3pdx80dhMOgyg9Gr+s7EzOG/j6uDWLCOO2Rsw
JqtIqiScIyTeVIxKWkZ7vhl1s7qIKPGQhghTcH53+wAOc1l9EoWh9/LCCRAhVqVx
BLQFT97ZLVnKTYbnq5siYQUvQ1VKJiAh9j5/uJAQtsBIxIPG271vgkoKp9mX0/ti
CDvp95+l2gBjPa6MDl0N1CT9OLtvWM14u63H6y4eYnb0VJxr10ogYgnLVgiKoWn7
y3TOLiY9VJ7+nrFNGB1HQVtQSQhn9jrg5RLq4xTVWCnPZHsyBwhy/Nt/mJ8uo7Nh
uAiaOmMPh6WXzeoTiEHvRRMZ+jObbNbci4nVUOAw7LvRTlmyz87hijgCzCWMMSES
chf7Z/5X2VN1tF45Rd5pNMZq97slViBq/wtl/KYn7GF7yElyubv40cpgxfNF9bVP
Bpz0HwdSxTo=
=A/Lc
-----END PGP SIGNATURE-----

--cW+P/jduATWpL925--
