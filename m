Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0HWQzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:55:46 -0400
Received: from vint.altlinux.org ([194.107.17.35]:51909 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0HWQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:55:42 -0400
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 12:55:41 EDT
Date: Mon, 23 Aug 2010 20:45:22 +0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "tytso@mit.edu" <tytso@mit.edu>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swhiteho@redhat.com" <swhiteho@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
        "konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>,
        Tejun Heo <tj@kernel.org>, "vst@vlnb.net" <vst@vlnb.net>,
        Christoph Hellwig <hch@lst.de>,
        "chris.mason@oracle.com" <chris.mason@oracle.com>
Subject: Re: [dm-devel] [PATCHSET block#for-2.6.36-post] block: replace
 barrier with sequenced flush
Message-ID: <20100823164522.GA9528@atlas.home>
Mail-Followup-To: Ric Wheeler <rwheeler@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, "tytso@mit.edu" <tytso@mit.edu>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"swhiteho@redhat.com" <swhiteho@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"James.Bottomley@suse.de" <James.Bottomley@suse.de>,
	"konishi.ryusuke@lab.ntt.co.jp" <konishi.ryusuke@lab.ntt.co.jp>,
	Tejun Heo <tj@kernel.org>, "vst@vlnb.net" <vst@vlnb.net>,
	Christoph Hellwig <hch@lst.de>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>
References: <1281616891-5691-1-git-send-email-tj@kernel.org>
 <20100820132214.GA6184@lst.de>
 <4C6E9CAF.5010202@redhat.com>
 <4C7269E9.9070304@kernel.org>
 <20100823124815.GA20095@lst.de>
 <4C727E96.5020801@redhat.com>
 <4C727F2B.6060501@fusionio.com>
 <4C729171.3030605@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <4C729171.3030605@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 23, 2010 at 11:19:13AM -0400, Ric Wheeler wrote:
[...]
> (2) hardware raid cards with internal buffer memory and on-card battery b=
ackup=20
> (they sit in your server, disks sit in jbod like expansion shelves). Thes=
e are=20
> fine if the drives in those shelves have write cache disabled.

Actually some of such cards keep write cache on the drives enabled and
issue FLUSH CACHE commands to the drives.  E.g., 3ware 9690SA behaves
like this at least with SATA drives (the FLUSH CACHE commands can be
seen after enabling performance monitoring - they often end up in the
"10 commands having the largest latency" table).  This can actually be
safe if the card waits for the FLUSH CACHE completion before making
the write cache data in its battery-backed memory available for reuse
(and the drive implements the FLUSH CACHE command correctly).

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxypaIACgkQW82GfkQfsqI94QCeLiRSclQhAVlFnmFnK49Fh41s
55EAn1CXk2dhHSW/+tvscDZYwHy5ZG37
=v7Fn
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
