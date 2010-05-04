Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0EDBzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 21:55:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:33304 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab0EDBzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 21:55:07 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 17/39] union-mount: Union mounts documentation
In-Reply-To: Your message of "Mon, 03 May 2010 16:12:16 PDT."
             <1272928358-20854-18-git-send-email-vaurora@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com>
            <1272928358-20854-18-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272938052_7027P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 03 May 2010 21:54:12 -0400
Message-ID: <31248.1272938052@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4BDF7E4A.0106,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272938052_7027P
Content-Type: text/plain; charset=us-ascii

On Mon, 03 May 2010 16:12:16 PDT, Valerie Aurora said:

> +File copyup
> +-----------
> +
> +Any system call that alters the data or metadata of a file on the
> +bottom layer, or creates or changes a hard link to it will trigger a
> +copyup of the target file from the lower layer to the topmost layer
> +
> + - open(O_WRITE | O_RDWR | O_APPEND | O_DIRECT)
> + - truncate()/open(O_TRUNC)
> + - link()
> + - rename()
> + - chmod()
> + - chown()/lchown()
> + - utimes()
> + - setxattr()/lsetxattr()

I spent some time looking at patch 27 trying to figure it out for myself,
but my lack of splice()-fu doomed me. :)

A few quick questions:

1) For calls like chmod() that only touch the metadata, does it still
trigger a copyup of the data, or just the affected metadata?

2) Is the copyup of data synchronous or async done in the background?
The comments in union_copyup_len() about "We raced with someone else"
imply this is synchronous - if so. probably a note should be made that
an open() may take a little while under some conditions.  There's a *lot* of
code out there that assumes that open() calls are *really* cheap.

I wonder how many programs don't correctly deal with an ENOSPC on open() of
an already existing file.

(The answers probably don't matter unless somebody ends up invoking a
copyup of a gigabyte file, which of course implies one of my users will end up
doing exactly that. :)

--==_Exmh_1272938052_7027P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL335EcC3lWbTT17ARAukfAJ9JufJrg3CkmW/B0Pi/hybGkmSLAwCggS2R
ZJ1K5Hw0i83ZLhe1WSRPpEk=
=JL33
-----END PGP SIGNATURE-----

--==_Exmh_1272938052_7027P--

