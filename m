Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1LUPem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:34:42 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:23510 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1LUPej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:34:39 -0500
Date: Wed, 21 Dec 2011 10:32:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Thomas Meyer <thomas@m3y3r.de>, Li Dongyang <lidongyang@novell.com>,
        Ian.Campbell@citrix.com
Subject: [GIT PULL] (xen) stable/for-jens-3.3 for 3.3 merge window.
Message-ID: <20111221153256.GA26580@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EF1FC67.011B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Jens,

Please git pull the following git branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.3

in your 3.3 drivers branch (which I don't see on your git tree actually?)

This branch provides a new feature to the blkback/blkfront protocol, which was
suggested by Christoph Hellwig which is the 'secure-discard' operation.

That is now implemented - it required a bit of packing the structs to re-use
a reserved field and doing tons of tests. As part of that feature, Li added
the support to passthrough the discard operation to the loopback device.

Also some code movement suggested by Jan Beulich and lastly a fix for
allocating an array.

Thanks and please pull!

 drivers/block/xen-blkback/blkback.c |   84 ++++++++++++++--------------------
 drivers/block/xen-blkback/common.h  |   67 ++++++++++++++++------------
 drivers/block/xen-blkback/xenbus.c  |   12 +++++
 drivers/block/xen-blkfront.c        |   79 +++++++++++++++++++++------------
 include/xen/interface/io/blkif.h    |   40 ++++++++++++++---
 5 files changed, 170 insertions(+), 112 deletions(-)

Konrad Rzeszutek Wilk (3):
      xen/blk[front|back]: Squash blkif_request_rw and blkif_request_discard together
      xen/blk[front|back]: Enhance discard support with secure erasing support.
      xen/blkback: Move processing of BLKIF_OP_DISCARD from dispatch_rw_block_io

Li Dongyang (1):
      xen-blkback: convert hole punching to discard request on loop devices

Thomas Meyer (1):
      xen-blkfront: Use kcalloc instead of kzalloc to allocate array


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJO8fwhAAoJEFjIrFwIi8fJhQwIAJUrWhmBp3kaRkiaXmMSxs82
TegjOqf0yzPb9LmCwVigEGREDU1AQ9Y6u5FeWySvhw5MxOCozB2fChsW1xtdBWNc
CmI0CpTdylf1o0ZamVbpMfbIa2pgGqVsJvza+/jjs7ISc57eBKm6TF39qGvNi5Lz
CscpBlhqdYMESpcbSuLua8cM8wP1+Llq/hmZpbvFSF9D2J8IV1Te7OhaCkc1pSsr
yWYxvyYyPd99UfVoBN4XfX/HhiwHSbbRXk8/RKjhCgDMVn/E2f14r3Y82bLes+1C
I6ZfYIm1e1hKyDbr3HkPwm8+JnjV1h8KQjTr51tReM0hb/ANTH48sRyWtTavzHU=
=gpqq
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
