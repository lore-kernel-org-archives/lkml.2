Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab0FNOvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:51:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45857 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0FNOvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RtJkLh3LTk/prZ9RWO5KAAtv3+dxMBLrHQDoxArH1lGywQ9HRzfuV2x/e1Xn9DKb0D
         26610asMNt2bi8QsHXqGoi5VkQYZah47wUmEVfS+QgTptO+Ogc0HiCzStfCeLWIzo5Ur
         ZJMgD2NW+GLBG5boqdwVu8dyApdl9nC9LI+1w=
Date: Mon, 14 Jun 2010 17:54:40 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
Message-ID: <20100614145439.GA3448@swordfish.minsk.epam.com>
References: <20100613203352.GA3577@swordfish>
 <1276461183.2659.4.camel@maxim-laptop>
 <201006140136.18652.rjw@sisk.pl>
 <20100614140941.GA3581@swordfish.minsk.epam.com>
 <20100614073853.6fa2f91f@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20100614073853.6fa2f91f@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/14/10 07:38), Arjan van de Ven wrote:
> > Hello,
> > Not sure if this simple solution is the correct one.
>=20
> it's not; the caller needs to pass in the cpu number I suspect for this
> to be really correct....
>=20
> I just returned from family emergency travel and will take a look today
>=20

I thought about patching

=2E/drivers/cpuidle/governors/menu.c:	if (nr_iowait_cpu())
=2E/drivers/cpuidle/governors/menu.c:	mult +=3D 10 * nr_iowait_cpu();
=2E/kernel/time/tick-sched.c:		if (nr_iowait_cpu() > 0)


decided to patch nr_iowait_cpu instead.


	Sergey

--DocE+STaALJfprDB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwWQq8ACgkQfKHnntdSXjR/awP+O5HdRDq12VkRDxQV6l971hZP
PD2Cc9wZJAcGYi3TZ0KsbwmwPB9KCJwci8NnYAPcXRJ8+NCAGko8EA4JJnliTSRg
xBdVfNfpSyG+nE7G+qSRkTNw3jLTiuCh9ds1wKdH0xKIdU/KU/ZDgdwwdx9sGUl9
Gfk3Ei8162pIvm38Ofo=
=/SOs
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
