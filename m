Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1DYDMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 23:12:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54801 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab1DYDMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 23:12:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
In-Reply-To: Your message of "Thu, 21 Apr 2011 15:42:33 EDT."
             <1303414954-3315-1-git-send-email-josef@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1303701080_5888P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 24 Apr 2011 23:11:20 -0400
Message-ID: <125854.1303701080@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4DB4E65C.000D,ss=1,fgs=0,
	ip=71.62.120.129,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1303701080_5888P
Content-Type: text/plain; charset=us-ascii

On Thu, 21 Apr 2011 15:42:33 EDT, Josef Bacik said:

> -SEEK_HOLE: this moves the file pos to the nearest hole in the file from the
> given position. 

Do we want the semantic to be "the nearest" hole?  Or did we really want "the
next" hole?  Loops like a bullet loaded in the chamber and pointed at the
programmer's foot if they aren't allowing for the fact that this can go
*backwards* in the file if the closest hole is towards the beginning.  Good way
to end up in an infinite loop or other messy...

Consider the obvious implementation of "skip over a hole" - lseek(SEEK_HOLE),
lseek(SEEK_DATA).  and start reading data because we've skipped over the hole.
Wrong - the second seek may have gone backwards if the data was only 4K away
but the hole was 64K in size...


--==_Exmh_1303701080_5888P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNtOZYcC3lWbTT17ARAkB2AKDk0fzyUs+QaUFRVh6wDYDvs5yiXgCg+9LO
gbr1xY/QAHlMo7lFrxDHxUw=
=/6Mr
-----END PGP SIGNATURE-----

--==_Exmh_1303701080_5888P--

