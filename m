Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab2GBCCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 22:02:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50275 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab2GBCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 22:02:15 -0400
Message-ID: <1341194519.4852.128.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 11/48] mm: correctly synchronize rss-counters at exit/exec
From: Ben Hutchings <ben@decadent.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 02 Jul 2012 03:01:59 +0100
In-Reply-To: <alpine.LSU.2.00.1207011150480.1905@eggly.anvils>
References: <20120701172008.252571630@decadent.org.uk>
	 <alpine.LSU.2.00.1207011150480.1905@eggly.anvils>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nsbdQLrz5sU6pqLw6boe"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nsbdQLrz5sU6pqLw6boe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-07-01 at 12:02 -0700, Hugh Dickins wrote:
> On Sun, 1 Jul 2012, Ben Hutchings wrote:
>=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Konstantin Khlebnikov <khlebnikov@openvz.org>
> >=20
> > commit 4fe7efdbdfb1c7e7a7f31decfd831c0f31d37091 upstream.
> >=20
> > do_exit() and exec_mmap() call sync_mm_rss() before mm_release() does
> > put_user(clear_child_tid) which can update task->rss_stat and thus make
> > mm->rss_stat inconsistent.  This triggers the "BUG:" printk in check_mm=
().
> >=20
> > Let's fix this bug in the safest way, and optimize/cleanup this later.
> >=20
> > Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [bwh: Backported to 3.2: sync_mm_rss() still takes a struct task_struct=
 *]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> If you or Konstantin or Oleg have done full diligence on this,
> to ensure that it is really applicable to 3.2 (not just that
> the patch applies without rejects), fair enough.

I can't claim that, no.

> But I'd be cautious about it: it went through enough alternatives
> and revisions that I wouldn't call it trivial; it's easy for me to
> imagine that some of the affected paths were actually slightly different
> in 3.2 days than they were in 3.4 days; and the disturbing warning that
> these mods silence ("BUG: Bad rss-counter state ") did not exist before
> 3.4 - unless you've ported that too?

No.

> That's not to assert that we had no rss problem at all before 3.4,
> but we've not heard of any trouble from it.  Caution tells me that
> this patch might cause more trouble than it's worth.

Then I'll assume this should be dropped unless Konstantin or Oleg speaks
up for it.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-nsbdQLrz5sU6pqLw6boe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/EBF+e/yOyVhhEJAQpVsBAAvqsQ/G98U2RbgDdOxMMSzAI8ZWstKXHn
ijmLjEMF2tx9IccmkLYRQc6ApayAtJ+s3OJtMgQtdkeiPw5OECPhUxHgsEcWAY20
rIXekj4Xs9cRie5pcXbprCLcU3mp7Bb72dlsm85PN62CYcyCFSrj82mS7sKQmJBp
PZTsi5Fli8mf4Jk14sGUsviYSaYIv69+mK3WGSSa2hs+dEMAxjdn20sAbr5pVGvT
ynRFzD08cpdXfPqkDD18/VSpny/4PibWldzCGGmWwJxZGx1AMhcdfO0+T9+pQ1Cc
S2n7CeW/2My196G1LYCoJcm5/+Au4D1GEtimKEwxuqnDnsP9b85Ksjwz/XrgbWaL
Z+uP6B5tGhs0BOq/JXPTUYmDRo3zd5cscurO6v9hfMd3dUU0b718nXXEi79KcxVS
QGT+4ntcv0OTEvKBf3Po5E3WFrUfDwC/+gWmnNL2Zddf78cFsZNr/bV/juRhaIRw
M00VdcBtUlQC3I9LtBu6rPvhc+HAq6UV61qiTlpzQLeRcy5d729HLDwrEM7kMwur
wOcs7arZW9E6Jep0axDH+wE98hcvFg+F4z30iPe6O6S1YAppeuAQcWD5c0UwPUEK
PMPSz3n8uPbtUd+UptlPl0RIL7ivir7XrMAbg/cE2K5cauBYaDBU2BmuHexc74lw
K6vpMG0fbaM=
=47Vg
-----END PGP SIGNATURE-----

--=-nsbdQLrz5sU6pqLw6boe--
