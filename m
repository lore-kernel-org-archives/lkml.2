Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0KKU3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:29:05 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52690 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0KKU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:29:03 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alexander Shishkin <virtuoso@slind.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 0/7] system time changes notification
In-Reply-To: Your message of "Thu, 11 Nov 2010 21:29:55 +0200."
             <1289503802-22444-1-git-send-email-virtuoso@slind.org>
From: Valdis.Kletnieks@vt.edu
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1289507293_5030P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Nov 2010 15:28:13 -0500
Message-ID: <22542.1289507293@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4CDC51DD.016A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1289507293_5030P
Content-Type: text/plain; charset=us-ascii

On Thu, 11 Nov 2010 21:29:55 +0200, Alexander Shishkin said:

> Consider we want stuff like "wakeup every day at 3pm", the next wakeup
> might be earlier than the timer we calculated last time, on system
> time changes. We need to re-calculate it. This is necessary for all
> repeating events.
> 
> Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
> hours. Now the system time changes to 2pm, and we would expect to
> wakeup in one hour, but we take 25.

Sorry, I tuned in late here...

So the plan is that if you're not using this new interface, it will go off at
the same absolute offset (23 hours after timer was set), but if you're using
this interface, your timer event gets interrupted, you get woken up (say)
15 hours into your 23, and it's your job to decide if you need to set a
new timer for the remaining 6, 7, 8 hours or some other number?

--==_Exmh_1289507293_5030P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM3FHdcC3lWbTT17ARAnS+AKDqRPbf6lT4T6W884lHo7TUsuIMiwCfXwdA
Z8a8yH7oN1rSmaxIbdB+cB4=
=vB6P
-----END PGP SIGNATURE-----

--==_Exmh_1289507293_5030P--

