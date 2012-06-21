Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244Ab2FUUbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:31:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57184 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760200Ab2FUUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:30:59 -0400
Message-ID: <1340310656.2536.12.camel@koala>
Subject: Re: [PATCH 4/4] hfsplus: get rid of write_super
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jun 2012 23:30:56 +0300
In-Reply-To: <20120621124158.a7559ee3.akpm@linux-foundation.org>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
	 <1339587471-2713-5-git-send-email-dedekind1@gmail.com>
	 <20120621124158.a7559ee3.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-CZkT9J/NKfEsZKyEoQ1F"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CZkT9J/NKfEsZKyEoQ1F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-21 at 12:41 -0700, Andrew Morton wrote:
> > +	spin_lock(&sbi->work_lock);
> > +	if (!sbi->work_queued) {
> > +	       delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);
> > +	       queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
> > +	       sbi->work_queued =3D 1;
> > +	}
> > +	spin_unlock(&sbi->work_lock);
> >  }
>=20
> And I think it could be made to go away here, perhaps by switching to
> test_and_set_bit or similar.

Yes, you are right, and I thought about this. But I did not want to make
it more complicated than needed. Spinlock is simple and
straight-forward, this is not a fast-path.

> And I wonder about the queue_delayed_work().  iirc this does nothing to
> align timer expiries, so someone who has a lot of filesystems could end
> up with *more* timer wakeups.  Shouldn't we do something here to make
> the system do larger amounts of work per timer expiry?  Such as the
> timer-slack infrastructure?

Well, I also thought about this. But I again did not want to invent
anything complex because main file systems - ext4, btrfs, xfs - do not
use 'write_super()' at all. And then only these dying / rare
file-systems like btrfs / hfs - I did not feel like over-engineering is
needed.

If someone is affected by more timers, which I really really doubt, we
can further optimize this using deferrable timers for some file-systems
which do not really think anything super-important, and we can use range
hrtimers for file-systems which sync something more or less important.
The former is easy to do, the latter would need improving the workqueue
infrastructure.


> It strikes me that this whole approach improves the small system with
> little write activity, but makes things worse for the larger system
> with a lot of filesystems?

Well, if we have a lot of those rare FSes and do not have much
activities, then we do not wake up. If we have a lot of activities,
probably it does not hurt to wake-up much. But of course there is a
situation when this would hurt, but I again, do doubt such systems are
common, an really care.

IOW, I do not dismiss your point, but I think that we rather see if it
affects anyone and then optimize with a deferrable/range timers.

--=20
Best Regards,
Artem Bityutskiy

--=-CZkT9J/NKfEsZKyEoQ1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP44SAAAoJECmIfjd9wqK01VcP/1p5i/WW2qGa+huQgHTYVS1m
xp/+8VWQFY0CNVbMCzAJr8e0DIibJEMddyKQtWYd35CVOlhC7gpDPSlXA+4JyjkU
No9YTYYivdGlRK+iYrsnePCE+BWNkNgpgwkgbSQ99P5kwxFuYbU3BkIDWrP/AlAm
7GozxAWCTSaNab7Q+YdSh5dpj+fDF33VcM0mUXm7FlRRKiY/J1+rPJ3QCZUK466t
yeE2w42s+3YY/jWgrPbG+rroycFq3l0g/fjaaV2PeAsjwiC4oUOCoxkryWwu3GJQ
f9H9mE9Ed2AIQGihkequaCQ85QCVsGmlRrZAF5eqkX9vobEKmXr2RvanOkWdpygr
jKo/JzFXCH9ZRM/R8ft/BjoGmCxYguiJZxuOghzm/z3ezbQtunxUmSEL+09I+kBj
BZl4hUozPdn3QdqV2pZ5vhbal40hnjjg6VzqSymbgYWzauM2aJp9m37OSpox8QFp
7iSgTY2tKmePrg41iI1YHSMaqOb7BFCJI9NY4pVdTDtOR1pikCRUb6kTElAAGRSZ
QXLyef3FaPf4lszSVhnlpQiTlc1tt25w8+l94mBhNqxh8zZvRlexRB29VAJe69v6
+qX4AfoPjfbAxLaFuuKeZxTHa8o9nTXntGOXdqhPKEIRyTRKMRzURfmOGI9gUyQa
+uRgjAb72Tmo+QpnCxAR
=kv0E
-----END PGP SIGNATURE-----

--=-CZkT9J/NKfEsZKyEoQ1F--

