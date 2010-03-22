Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0CVUmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:42:12 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:51751 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab0CVUmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:42:09 -0400
X-Spam-ASN: 
Date: Mon, 22 Mar 2010 23:42:01 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv2 0/6] pps: time synchronization over LPT
Message-ID: <20100322234201.73ffc06a@tornado.gnet>
In-Reply-To: <1f1b08da1003081925p61a810e4v96be56640287d61@mail.gmail.com>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
	<1f1b08da1003081925p61a810e4v96be56640287d61@mail.gmail.com>
Organization: LVK
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/llDhB6UBtjTXP=iTraVM25M"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/llDhB6UBtjTXP=iTraVM25M
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi John,

Sorry for the delay...

=D0=92 Mon, 8 Mar 2010 19:25:07 -0800
john stultz <johnstul@us.ibm.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Wed, Feb 24, 2010 at 4:28 AM, Alexander Gordeev
> <lasaine@lvk.cs.msu.su> wrote:
> > This patchset is tested against the vanilla 2.6.32.9 kernel. But we
> > are actually using it on 2.6.31.12-rt20 rt-preempt kernel most of
> > the time. Also there is a version which should be applied on top of
> > LinuxPPS out of tree patches (i.e. all clients and low-level irq
> > timestamps stuff). Those who are interested in other versions of
> > the patchset can find them in my git repository:
> > http://lvk.cs.msu.su/~lasaine/timesync/linux-2.6-timesync.git
> >
> > There is one problem however: hardpps() works bad when used on top
> > of 2.6.33-rc* with CONFIG_NO_HZ enabled. The reason for this is
> > commit a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it
> > hardpps() is able to sync to 1us precision in about 10 seconds.
> > With it
>=20
> Uh. Not sure I see right off why the logarithmic time accumulation
> would give you troubles. Its actually there to try to fix a couple of
> NTP issues that cropped up when the accumulation interval was pushed
> out to 2HZ with CONFIG_NO_HZ.

Yes, I know. I guess (based on the commit log and other sources) that
this change was added to make chrony work better on tickless kernel.
So chrony corrects the time using only frequency corrections?
My approach is different: use time_offset t remove the phase error and
adjust time_freq to remove frequency error.

> Do you have any extra insight here as to whats going on with your
> code?   The only thing I could guess would be second_overflow() is
> happening closer to the actual overflow, but maybe less regularly? But
> again, I'm not sure how this would be drastically different then
> before with the 2HZ accumulation period.

I still can't find this out (partially because I'm too busy with other
tasks). The new code seems ok to mee. time_offset is added at
second_overflow as usual. Maybe the problem is with the frequency
correction. I'm going to run some tests that should show where the
problem is: in the phase or freq correction.

I hope I'll have time for this next week.

--=20
  Alexander

--Sig_/llDhB6UBtjTXP=iTraVM25M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLp9YZAAoJEElrwznyooJbTrAIAIqUfdCrComz+0TRZcE41ZIz
bTvMsEfiVOlwGjYU2y/CMnAmslImwexyC8eRqwh1zPIBCNz7zb1sXLQvHtVdNyOR
gI+Cg+TaeCqky7KW93owZjxnrN/pt4PeYBky2aUkOy7cMsikTFnuGxncyvk3ObpQ
UTXkkMpy1fpqMpvzyEZt8sPlrTkswiHRQhE71SIGymxgOJNpqcreiORgSsuruB3C
5QPBTm2gK9nEHw4OitZ5D5Sk5eWbaKPLkoVmiGlLRSEezKByEydxKoe5jc26f7CP
5im80yD9SR+AMoDtQ1gm+WEWZhSC9MPKvgksoRY5xZztM3kaIwcofozgZC/d2vo=
=oBU2
-----END PGP SIGNATURE-----

--Sig_/llDhB6UBtjTXP=iTraVM25M--
