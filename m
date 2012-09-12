Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2ILM2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:28:40 -0400
Received: from shamrock.taprogge.org ([213.146.117.139]:57896 "EHLO
	shamrock.taprogge.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2ILM2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:28:39 -0400
Date: Wed, 12 Sep 2012 14:28:14 +0200
From: Jens Taprogge <jens.taprogge@taprogge.org>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new
 callbacks to tpci200
Message-ID: <20120912122814.GB7164@endeavour.taprogge.org>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-3-git-send-email-siglesias@igalia.com>
 <20120911084702.GM19396@mwanda>
 <20120912092833.GA24558@endeavour.taprogge.org>
 <20120912111330.GD19396@mwanda>
 <1347448877.4539.164.camel@fourier.local.igalia.com>
 <20120912115926.GF19396@mwanda>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20120912115926.GF19396@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 7bit
X-Anti-Spam: Skipped scanning; message comes from a trusted host.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 12, 2012 at 02:59:26PM +0300, Dan Carpenter wrote:
> On Wed, Sep 12, 2012 at 01:21:17PM +0200, Samuel Iglesias Gons=E1lvez w=
rote:
> > On Wed, 2012-09-12 at 14:13 +0300, Dan Carpenter wrote:
> > > On Wed, Sep 12, 2012 at 11:28:33AM +0200, Jens Taprogge wrote:
> > > > On Tue, Sep 11, 2012 at 11:47:02AM +0300, Dan Carpenter wrote:
> > > > > > +static int tpci200_get_clockrate(struct ipack_device *dev)
> > > > > > +{
> > > > > > +	struct tpci200_board *tpci200 =3D check_slot(dev);
> > > > > > +	__le16 __iomem *addr;
> > > > >=20
> > > > > The point of the underscores in the __le16 is that you don't wa=
nt to
> > > > > pollute user space headers in glibc with a bunch of kernel type=
defs.
> > > > > It is not needed here.  (Or if it is, then we would need to rep=
lace
> > > > > the u16 uses as well).
> > > >=20
> > > > I was under the impression that "__le16" is used to indicate the
> > > > byteorder of the pointed to memory.  As far as I can see that
> > > > information is lost when we use u16.  Am I missing something?
> > > >=20
> > >=20
> > > Use the no-underscore version unless it's inside a header which is
> > > exported to userspace.
> > >=20
> > > 	le16 __iomem *addr;
> > >=20
> >=20
> > But it is not declared in linux/types, it is?
> >=20
> > I have found only this typedef in a quick search:
> >=20
> > http://lxr.linux.no/#linux+v3.5.3/fs/ntfs/types.h#L28
> >=20
> > Should we define them in ipack.h header file or they are defined in
> > other place?
> >=20
>=20
> Oh crap!  You're right.  That's embarrassing.  I'm just totally
> wrong here.  Sorry for that.
>=20
> regards,
> dan carpenter

Sam,

can you please add the endianess-aware versions back?  Patch attached.

One of the earlier uses was not correct.

Best Regards,
Jens

--BOKacYhQ+x31HxR3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-staging-ipack-bridges-tpci200-Use-endianess-aware-ty.patch"

>From 3ed4dd686dec8b8b6fed1a35752daf4525002d0c Mon Sep 17 00:00:00 2001
From: Jens Taprogge <jens.taprogge@taprogge.org>
Date: Wed, 12 Sep 2012 14:25:25 +0200
Subject: [PATCH] staging: ipack/bridges/tpci200: Use endianess-aware types
 where applicable.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
---
 drivers/staging/ipack/bridges/tpci200.c |   10 +++++-----
 drivers/staging/ipack/bridges/tpci200.h |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 5341aa8..af1cac8 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -357,7 +357,7 @@ out_disable_pci:
 static int tpci200_get_clockrate(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 
 	if (!tpci200)
 		return -ENODEV;
@@ -369,7 +369,7 @@ static int tpci200_get_clockrate(struct ipack_device *dev)
 static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 
 	if (!tpci200)
 		return -ENODEV;
@@ -392,7 +392,7 @@ static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
 static int tpci200_get_error(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 	u16 mask;
 
 	if (!tpci200)
@@ -406,7 +406,7 @@ static int tpci200_get_error(struct ipack_device *dev)
 static int tpci200_get_timeout(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 	u16 mask;
 
 	if (!tpci200)
@@ -421,7 +421,7 @@ static int tpci200_get_timeout(struct ipack_device *dev)
 static int tpci200_reset_timeout(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 	u16 mask;
 
 	if (!tpci200)
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 3327025..982f319 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -37,12 +37,12 @@
 #define TPCI200_MEM8_SPACE_BAR        5
 
 struct tpci200_regs {
-	u16	revision;
+	__le16	revision;
 	/* writes to control should occur with the mutex held to protect
 	 * read-modify-write operations */
-	u16  control[4];
-	u16	reset;
-	u16	status;
+	__le16  control[4];
+	__le16	reset;
+	__le16	status;
 	u8	reserved[242];
 } __packed;
 
-- 
1.7.9.5


--BOKacYhQ+x31HxR3--
