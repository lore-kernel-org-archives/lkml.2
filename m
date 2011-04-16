Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1DPOR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:17:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49553 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1DPORV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:17:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: haojian.zhuang@gmail.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 01/13] input: touchscreen: use polling mode in 88pm860x
In-Reply-To: Your message of "Sat, 16 Apr 2011 20:46:20 +0800."
             <1302957980-27343-1-git-send-email-haojian.zhuang@marvell.com>
From: Valdis.Kletnieks@vt.edu
References: <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>
            <1302957980-27343-1-git-send-email-haojian.zhuang@marvell.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302963433_54890P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Apr 2011 10:17:13 -0400
Message-ID: <60599.1302963433@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4DA9A4EC.010A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302963433_54890P
Content-Type: text/plain; charset=us-ascii

On Sat, 16 Apr 2011 20:46:20 +0800, Haojian Zhuang said:
> Measuring point on touchscreen with IRQ mode can only monitor pen-down
> event. If finger is moving on touchscreen, it can't be monitored by
> IRQ pen-down event. So switch to polling mode after pen-down event.

>  drivers/input/touchscreen/88pm860x-ts.c |   79 ++++++++++++++++++++++++------

> +/*
> + * While 32KHz hardware timer is used for scheduler, we always assign HZ
> + * to 128. It means that 1 tick costs 7.8msec.
> + */
> +#define MEASURE_INTERVAL_MS	(7)

Is it guaranteed that this hardware part will only ever be used on systems
where this is true?  How big a bug would it be if somebody tried to glue this
touchscreen into some random embedded-ARM where HZ was something else, and
should this be computed as a function of HZ instead of hardcoding 7?

It *looks* like the intent of the schedule_delayed_work() call is "let's run
this once a tick when we're awake *anyhow*" - but looking at the code, I can't
convince myself a rounding error in computing 'interval' won't schedule 1ms
before or after the next tick would have been.  Isn't there a better API with
slack timers or something that would do a better "next tick" job?




--==_Exmh_1302963433_54890P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqaTpcC3lWbTT17ARAtE0AKDQCwt8g16kcAwSD8sUToP/pr5EZQCgziyT
27qstpI9mLYp/MzJMmb2u94=
=p6Cs
-----END PGP SIGNATURE-----

--==_Exmh_1302963433_54890P--

