Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1I2Q7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:59:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56083 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1I2Q7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:59:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
        kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
In-Reply-To: Your message of "Thu, 29 Sep 2011 20:18:48 +0400."
             <20110929161848.GA16348@albatros>
From: Valdis.Kletnieks@vt.edu
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros> <alpine.DEB.2.00.1109271459180.13797@router.home> <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
            <20110929161848.GA16348@albatros>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1317315452_4004P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Sep 2011 12:57:32 -0400
Message-ID: <23921.1317315452@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4E84A37F.00CB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1317315452_4004P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Sep 2011 20:18:48 +0400, Vasiliy Kulikov said:

> As `new' is just increased, it means it is known with KB granularity,
> not MB.  By counting used slab objects he learns filled_obj_size_sum.
> 
> So, rounding gives us nothing, but obscurity.

Yes, but if he has an exploit that requires using up (for example) exactly 31
objects in the slab, he may now know that a new slab got allocated to push it
over the MB boundary.  So he knows there's exactly one object in that new slab.

But now he has to fly blind for the next 30 because the numbers will display
exactly the same, and he can't correct for somebody else allocating one so he
needs to only allocate 29...


--==_Exmh_1317315452_4004P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOhKN8cC3lWbTT17ARAg/3AJ9x3uaMuHNlfdBtk8pRkToHP403mACglOOW
87NfvBJfy887ga+I5IdAQY0=
=H0IU
-----END PGP SIGNATURE-----

--==_Exmh_1317315452_4004P--

