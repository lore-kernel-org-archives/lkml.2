Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1GIR7y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 13:59:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44092 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1GIR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 13:59:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
In-Reply-To: Your message of "Thu, 07 Jul 2011 15:33:21 EDT."
             <20110707193321.GE28850@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20110704170922.976299676@linux.vnet.ibm.com> <20110705202615.GJ24348@redhat.com> <1309944287.3937.39.camel@br98xy6r>
            <20110707193321.GE28850@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1310234299_3224P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 09 Jul 2011 13:58:19 -0400
Message-ID: <49979.1310234299@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4E1896C1.0102,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1310234299_3224P
Content-Type: text/plain; charset=us-ascii

On Thu, 07 Jul 2011 15:33:21 EDT, Vivek Goyal said:
> On Wed, Jul 06, 2011 at 11:24:47AM +0200, Michael Holzheu wrote:

> > S390 stand-alone dump tools are independent mini operating systems that
> > are installed on disks or tapes. When a dump should be created, these
> > stand-alone dump tools are booted. All that they do is to write the dump
> > (current memory plus the CPU registers) to the disk/tape device.
> > 
> > The advantage compared to kdump is that since they are freshly loaded
> > into memory they can't be overwritten in memory.
> 
> > Another advantage is
> > that since it is different code, it is much less likely that the dump
> > tool will run into the same problem than the previously crashed kernel.
> 
> I think in practice this is not really a problem. If your kernel
> is not stable enough to even boot and copy a file, then most likely
> it has not even been deployed. The very fact that a kernel has been
> up and running verifies that it is a stable kernel for that machine
> and is capable of capturing the dump.

Vivek: I used to do VM/XA on S/390 boxes for a living, and that's *not* where
Michael is coming from.

What the standalone dump code does is take a system that may have the moral
equivalent of 256 separate PCI buses, several hundred disks all visible in
multipath configurations, dozens of other devices, and as long as you can find
*one* console and *one* tape/disk drive that works, you can capture a dump.

More than once in my career, I got into a situation where the production system
would hang - and booting off another disk that contained an older copy with
maybe a few less patches would *also* hang.  VM/XA would simply *not run*.
Booting the standalone dump utility (which shared zero code with VM/XA, and did
*much* less initialization of I/O devices not needed for the actual dump) would
work just fine.  This would get me a dump that would show that we had a
(usually) hardware issue - either we were tripping over an errata that *no*
released version of VM/XA had a workaround for, or outright defective hardware.

For the same efficiency reasons that Linux doesn't do a lot of checking for
"can never happen" cases, VM/XA doesn't check some things. So when busted
hardware would present logically impossible combinations of status bits (for
instance, "device still connected" but "I/O bus disconnected"), Bad Things
would happen.  Booting a tiny dump program that never even *tried* to look at
the bad bits posted by the miscreant hardware would allow you to get the info
you needed to debug it.

*THAT* is the use case -  when you have one customer out there in East Podunk
who is consistently managing to hang their system so hard you can't get enough
info out of it to figure out what's broken.



--==_Exmh_1310234299_3224P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOGJa7cC3lWbTT17ARAkNgAKCvbzRrZ+16B+dtYxGPzQJnYhLbbQCg4vpO
5ElDD8Y1iavSssFn2LoU7YM=
=y6K2
-----END PGP SIGNATURE-----

--==_Exmh_1310234299_3224P--

