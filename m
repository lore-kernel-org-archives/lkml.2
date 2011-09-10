Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1IJAva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:51:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53929 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab1IJAv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:51:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] zram: Set initial disksize to some default value
In-Reply-To: Your message of "Fri, 09 Sep 2011 20:18:56 EDT."
             <4E6AACF0.2080907@vflare.org>
From: Valdis.Kletnieks@vt.edu
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org> <1315609264-13632-6-git-send-email-ngupta@vflare.org> <20110909231209.GB24604@kroah.com>
            <4E6AACF0.2080907@vflare.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1315615809_28234P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Sep 2011 20:50:09 -0400
Message-ID: <62714.1315615809@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E6AB446.000C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1315615809_28234P
Content-Type: text/plain; charset=us-ascii

On Fri, 09 Sep 2011 20:18:56 EDT, Nitin Gupta said:
> On 09/09/2011 07:12 PM, Greg KH wrote:
> 
> > On Fri, Sep 09, 2011 at 07:01:04PM -0400, Nitin Gupta wrote:
> >> Currently, we set initial disksize as 0, which forces
> >> user to write some value to corresponding zram device's
> >> sysfs node, before the device can be used. Now, we avoid
> >> this step by providing some default size initially.
> >>
> >> To change the disksize, user must:
> >>  - Reset disk.
> >> 	Ex: echo 1 > /sys/block/zram0/reset
> >> (NOTE: disksize is set to the default value after reset)
> >>
> >>  - Set new disksize.
> >> 	Ex: echo $((256*1024*1024)) > /sys/block/zram0/disksize
> > 
> > So, what tools just broke with this change?
> > 
> > And where is the sysfs file documentation change that should go along
> > with this?
> > 
> 
> 
> This change does not change any sysfs names or behavior, so does not
> break any scripts that assume the current behavior.

Consider the current case:   We init size to zero, and a startup script changes
it to 1024 and then sticks 768 of data in there.  No Problem.

We now get a kernel that's built with a default of 512.  The startup script
tries to change it to 1024, but doesn't know it has to splat something into
'reset' for it to actually work.  It then tries to stick 768 of data in there,
and hilarity ensues...

If I haven't misunderstood...


--==_Exmh_1315615809_28234P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOarRBcC3lWbTT17ARAubzAJ9v1P68zpyBFPAYenmF/dx5fg2jqgCfZMpi
idgLkO5bHcfp3HNJ+A/MD6Y=
=uq4i
-----END PGP SIGNATURE-----

--==_Exmh_1315615809_28234P--

