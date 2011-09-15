Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935527Ab1IOX5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:57:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34456 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934969Ab1IOX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:57:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-mm@kvack.org,
        ngupta@vflare.org, linux-kernel@vger.kernel.org,
        francis.moro@gmail.com, dan.magenheimer@oracle.com
Subject: Re: [PATCH] staging: zcache: fix cleancache crash
In-Reply-To: Your message of "Tue, 13 Sep 2011 14:19:22 CDT."
             <1315941562-25422-1-git-send-email-sjenning@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <4E6FA75A.8060308@linux.vnet.ibm.com>
            <1315941562-25422-1-git-send-email-sjenning@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316131006_4167P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Sep 2011 19:56:46 -0400
Message-ID: <23267.1316131006@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4E7290C2.0009,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316131006_4167P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Sep 2011 14:19:22 CDT, Seth Jennings said:
> After commit, c5f5c4db, cleancache crashes on the first
> successful get. This was caused by a remaining virt_to_page()
> call in zcache_pampd_get_data_and_free() that only gets
> run in the cleancache path.
> 
> The patch converts the virt_to_page() to struct page
> casting like was done for other instances in c5f5c4db.
> 
> Based on 3.1-rc4
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

I was seeing all sorts of bizzare memory corruptions and panics
and crashes while testing zcache - average uptime was only 2-3 hours.
With this patch applied, now have close to 24 hours of crash-free operation.
Feel free to add this if it isn't in somebody's tree already:

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1316131006_4167P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOcpC+cC3lWbTT17ARArIUAJ4qEl1NZKDoZb0qr2LrbkJXqAo3cwCgiEir
4nFzV83wIlYhsv5Se2xEdzI=
=GZc5
-----END PGP SIGNATURE-----

--==_Exmh_1316131006_4167P--

