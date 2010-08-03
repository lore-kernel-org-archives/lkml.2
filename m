Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0HCPN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:13:59 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57590 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab0HCPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:13:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, linux-usb@vger.kernel.org,
        dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set but not used
In-Reply-To: Your message of "Tue, 03 Aug 2010 10:29:52 EDT."
             <Pine.LNX.4.44L0.1008031027250.1853-100000@iolanthe.rowland.org>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.44L0.1008031027250.1853-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280848412_4165P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Aug 2010 11:13:32 -0400
Message-ID: <66093.1280848412@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C58321D.00D4,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280848412_4165P
Content-Type: text/plain; charset=us-ascii

On Tue, 03 Aug 2010 10:29:52 EDT, Alan Stern said:
> On Tue, 3 Aug 2010 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Mon, 02 Aug 2010 21:26:28 PDT, "Justin P. Mattock" said:
> > > diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
> > 
> > >  	if (alt->string)
> > > -		retval = device_create_file(&intf->dev, &dev_attr_interface);
> > > +		device_create_file(&intf->dev, &dev_attr_interface);
> > >  	intf->sysfs_files_created = 1;
> > >  	return 0;
> 
> Justin, did you try compiling your new code?  Those unused values are 
> there because device_create_file is declared as __must_check.
> 
> > What should the code do if device_create_file() manages to fail? Yes, ignoring
> > the return value is one option, but is it the best one?  'return ret;' might be
> > another one. Somebody who understands this code and has more caffeine than me
> > should look this over.
> 
> Failure to create a file in sysfs is almost never fatal and usually not 
> even dangerous.  Ignoring the error is generally better than failing 
> the entire operation.

Then why the __must_check attribute if it's usually ignorable? I thought
that was reserved for functions that you damned sight better well check
for errors because bad things are afoot otherwise?

--==_Exmh_1280848412_4165P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWDIccC3lWbTT17ARAnlYAJ9YUnEY9VVcanAxwJTBijx2PGbXhQCgvUEX
SMYBvT+YenrSRPl34ZkhVtY=
=JeBW
-----END PGP SIGNATURE-----

--==_Exmh_1280848412_4165P--

