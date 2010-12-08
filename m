Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab0LHU0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:26:19 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38064 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0LHU0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:26:17 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
In-Reply-To: Your message of "Tue, 07 Dec 2010 08:25:26 +0100."
             <1291706726-8835-1-git-send-email-rydberg@euromail.se>
From: Valdis.Kletnieks@vt.edu
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291839964_4921P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Dec 2010 15:26:04 -0500
Message-ID: <25336.1291839964@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4CFFE9DD.0079,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291839964_4921P
Content-Type: text/plain; charset=us-ascii

On Tue, 07 Dec 2010 08:25:26 +0100, Henrik Rydberg said:
> Today, userspace sets up an input device based on the data it emits.
> This is not always enough; a tablet and a touchscreen may emit exactly
> the same data, for instance, but the former should be set up with a
> pointer whereas the latter does not need to. Recently, a new type of
> touchpad has emerged where the buttons are under the pad, which changes
> handling logic without changing the emitted data. This patch introduces
> a new ioctl, EVIOCGDEVINFO, which allows userspace to extract information
> about the device resulting in proper setup.

>  /*
> + * Device types
> + */
> +
> +#define DEVTYPE_KEYBOARD	0
> +#define DEVTYPE_MOUSE		1
> +#define DEVTYPE_JOYSTICK	2
> +#define DEVTYPE_TOUCHPAD	3
> +#define DEVTYPE_TABLET		4
> +#define DEVTYPE_TOUCHSCREEN	5

Add a #define DEVTYPE_UNKNOWN 0 and push everybody else down one. That way,
an uninitialized 'struct input_devinfo' won't claim to be a keyboard.

--==_Exmh_1291839964_4921P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM/+nccC3lWbTT17ARApKUAJ4l6nWDQaSSwguhEph4vGmCkqHGLwCg5pAb
7FKTndnt1MZCDQaN2EOhPYM=
=6hTg
-----END PGP SIGNATURE-----

--==_Exmh_1291839964_4921P--

