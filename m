Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1JZTGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:06:53 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:38755 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1JZTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:06:51 -0400
X-Greylist: delayed 2386 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 15:06:51 EDT
Date: Wed, 26 Oct 2011 20:26:50 +0200
From: Matthijs Kooijman - Brevidius <matthijs@brevidius.nl>
To: Gaudenz Steinlin <gaudenz@debian.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines
	(Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20111026182650.GL14392@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman - Brevidius <matthijs@brevidius.nl>,
	Gaudenz Steinlin <gaudenz@debian.org>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org,
	Jameson Graef Rollins <jrollins@finestructure.net>,
	Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
	Martin Pitt <martin.pitt@ubuntu.com>
References: <20110406121920.GC4142@mtj.dyndns.org> <20110903221456.GA2877@elie> <20110904024244.GB3083@htj.dyndns.org> <87y5y37o7h.fsf@servo.factory.finestructure.net> <20110906174524.GN18425@mtj.dyndns.org> <20110907085037.GX10237@login.drsnuggles.stderr.nl> <20110911040826.GP29319@htj.dyndns.org> <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VLIBou5mBM6+kGHE"
Content-Disposition: inline
In-Reply-To: <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me>
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
Organization: Brevidius Multimedia Projecten
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VLIBou5mBM6+kGHE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

it seems this same problem also occurs with udisks-daemon, though the
behaviour is slightly different (it seems to hang even before
undocking, I _think_).

Anyway, here's the dmesg output when trying to suspend:

[26806.508362] Freezing of tasks failed after 20.01 seconds (1 tasks refusi=
ng to freeze, wq_busy=3D0):
[26806.508392] udisks-daemon   D ffff88023192cfa0     0  4250   4248 0x0080=
0004
[26806.508399]  ffff88023192cfa0 0000000000000086 ffffffff8103a613 ffffffff=
8134384c
[26806.508405]  ffff88022507f160 0000000000012f00 ffff880225a91fd8 ffff8802=
25a91fd8
[26806.508410]  0000000000012f00 ffff88023192cfa0 0000000000012f00 00000000=
00012f00
[26806.508416] Call Trace:
[26806.508428]  [<ffffffff8103a613>] ? need_resched+0x1a/0x23
[26806.508435]  [<ffffffff8134384c>] ? __schedule+0x598/0x5af
[26806.508441]  [<ffffffff81343d04>] ? schedule_timeout+0x2d/0xd7
[26806.508444]  [<ffffffff8103a3a0>] ? test_tsk_need_resched+0xe/0x17
[26806.508447]  [<ffffffff8103a471>] ? check_preempt_curr+0x54/0x61
[26806.508449]  [<ffffffff8103a509>] ? ttwu_do_wakeup+0x51/0xcb
[26806.508455]  [<ffffffff81074878>] ? arch_local_irq_save+0x14/0x1d
[26806.508457]  [<ffffffff81343961>] ? wait_for_common+0x9d/0x116
[26806.508461]  [<ffffffff81041288>] ? try_to_wake_up+0x199/0x199
[26806.508465]  [<ffffffff8105d9dd>] ? start_flush_work+0xec/0x103
[26806.508468]  [<ffffffff8105dcf3>] ? flush_work+0x24/0x2c
[26806.508470]  [<ffffffff8105d606>] ? do_work_for_cpu+0x1b/0x1b
[26806.508474]  [<ffffffff8119f8e1>] ? disk_clear_events+0x86/0xe5
[26806.508504]  [<ffffffff81125bf0>] ? check_disk_change+0x22/0x50
[26806.508510]  [<ffffffffa00ab02e>] ? sd_open+0xeb/0x197 [sd_mod]
[26806.508513]  [<ffffffff8112696e>] ? __blkdev_get+0xe0/0x37d
[26806.508515]  [<ffffffff81126eb2>] ? blkdev_get+0x2a7/0x2a7
[26806.508517]  [<ffffffff81126dd2>] ? blkdev_get+0x1c7/0x2a7
[26806.508519]  [<ffffffff81126eb2>] ? blkdev_get+0x2a7/0x2a7
[26806.508523]  [<ffffffff810fce44>] ? __dentry_open+0x17f/0x296
[26806.508527]  [<ffffffff811064a1>] ? dget+0x12/0x1e
[26806.508530]  [<ffffffff8110953f>] ? do_last+0x479/0x57e
[26806.508533]  [<ffffffff81109cb5>] ? path_openat+0xce/0x350
[26806.508536]  [<ffffffff81109f80>] ? do_filp_open+0x2c/0x72
[26806.508538]  [<ffffffff813438ad>] ? _cond_resched+0x9/0x20
[26806.508541]  [<ffffffff811b342d>] ? __strncpy_from_user+0x19/0x4a
[26806.508545]  [<ffffffff81113184>] ? alloc_fd+0x69/0x110
[26806.508547]  [<ffffffff810fdbda>] ? do_sys_open+0x5f/0xe6
[26806.508552]  [<ffffffff81349e52>] ? system_call_fastpath+0x16/0x1b

Not sure if this helps, but I wanted to share this in case it does.

Met vriendelijke groet,

Matthijs Kooijman

--=20
Brevidius Multimedia Projecten      | www.brevidius.nl
Alexander Boersstraat 28            | matthijs@brevidius.nl
1071 KZ Amsterdam                   | tel. +31634764539

--VLIBou5mBM6+kGHE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk6oUOoACgkQz0nQ5oovr7ys0ACfULU1Lde00JP0Zntu8rvc24+Q
4woAn0a7LBpL/Z956c+N1NGywK3pnHzG
=LOjO
-----END PGP SIGNATURE-----

--VLIBou5mBM6+kGHE--
