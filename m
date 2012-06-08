Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab2FHF2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:28:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63357 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462Ab2FHF2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:28:49 -0400
Date: Thu, 7 Jun 2012 22:28:17 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: akpm@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, khlebnikov@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de,
        oleg@redhat.com, stable@vger.kernel.org
Subject: Re: [patch 12/12] mm: correctly synchronize rss-counters at
 exit/exec
In-Reply-To: <CA+55aFw7y5FBJm6pxiHHsoiPaVQG3A+4u6J9=4DGd8kVPjmzGQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1206072220200.1738@eggly.anvils>
References: <20120607212114.E4F5AA02F8@akpm.mtv.corp.google.com> <CA+55aFxOWR_h1vqRLAd_h5_woXjFBLyBHP--P8F7WsYrciXdmA@mail.gmail.com> <CA+55aFyQUBXhjVLJH6Fhz9xnpfXZ=9Mej5ujt6ss7VUqT1g9Jg@mail.gmail.com> <alpine.LSU.2.00.1206071759050.1291@eggly.anvils>
 <CA+55aFw7y5FBJm6pxiHHsoiPaVQG3A+4u6J9=4DGd8kVPjmzGQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2106132903-1339133305=:1738"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2106132903-1339133305=:1738
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 7 Jun 2012, Linus Torvalds wrote:
> No, this is apparently that same "almost there" patch from Oleg. I
> guarantee that it's wrong.
>=20
>                 Linus
>=20
> ---
>=20
> [ This part, to be exact: ]
>=20
> On Thu, Jun 7, 2012 at 6:16 PM, Hugh Dickins <hughd@google.com> wrote:
> > --- a/kernel/tsacct.c
> > +++ b/kernel/tsacct.c
> > @@ -91,6 +91,7 @@ void xacct_add_tsk(struct taskstats *stats, struct ta=
sk_struct *p)
> > =A0 =A0 =A0 =A0stats->virtmem =3D p->acct_vm_mem1 * PAGE_SIZE / MB;
> > =A0 =A0 =A0 =A0mm =3D get_task_mm(p);
> > =A0 =A0 =A0 =A0if (mm) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sync_mm_rss(mm);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* adjust to KB unit */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stats->hiwater_rss =A0 =3D get_mm_hiwate=
r_rss(mm) * PAGE_SIZE / KB;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stats->hiwater_vm =A0 =A0=3D get_mm_hiwa=
ter_vm(mm) =A0* PAGE_SIZE / KB;
> > --

Yup.

It does look as if Oleg's intent (last chance to update xacct stats
from dying current task) would be well served by changing that to

=09=09if (p =3D=3D current)
=09=09=09sync_mm_rss(mm);

but I've made too many hurried decisions recently to sign off on that.

Hugh
--8323584-2106132903-1339133305=:1738--
