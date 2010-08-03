Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0HCL2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:28:40 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41813 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0HCL2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:28:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set but not used
In-Reply-To: Your message of "Mon, 02 Aug 2010 21:26:28 PDT."
             <1280809589-23649-1-git-send-email-justinmattock@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1280809589-23649-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280834905_4165P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Aug 2010 07:28:25 -0400
Message-ID: <58611.1280834905@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4C57FD5A.01AB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280834905_4165P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Aug 2010 21:26:28 PDT, "Justin P. Mattock" said:
> diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c

>  	if (alt->string)
> -		retval = device_create_file(&intf->dev, &dev_attr_interface);
> +		device_create_file(&intf->dev, &dev_attr_interface);
>  	intf->sysfs_files_created = 1;
>  	return 0;

What should the code do if device_create_file() manages to fail? Yes, ignoring
the return value is one option, but is it the best one?  'return ret;' might be
another one. Somebody who understands this code and has more caffeine than me
should look this over.

(Nothing personal Justin - it's just my opinion that *anytime* we have a patch
that remove a check for a return code, it needs to justify that ignoring the
return code is appropriate).


--==_Exmh_1280834905_4165P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMV/1ZcC3lWbTT17ARAnQiAKCjcjMn62jke6aBWRDoRTwK6hku+wCgg4QH
QFnbYVqvu+q0psxI7JZDZl4=
=m5gp
-----END PGP SIGNATURE-----

--==_Exmh_1280834905_4165P--

