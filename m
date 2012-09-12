Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab2ILMAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:00:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19835 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2ILMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:00:14 -0400
Date: Wed, 12 Sep 2012 14:59:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new
 callbacks to tpci200
Message-ID: <20120912115926.GF19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-3-git-send-email-siglesias@igalia.com>
 <20120911084702.GM19396@mwanda>
 <20120912092833.GA24558@endeavour.taprogge.org>
 <20120912111330.GD19396@mwanda>
 <1347448877.4539.164.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347448877.4539.164.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 01:21:17PM +0200, Samuel Iglesias Gonsálvez wrote:
> On Wed, 2012-09-12 at 14:13 +0300, Dan Carpenter wrote:
> > On Wed, Sep 12, 2012 at 11:28:33AM +0200, Jens Taprogge wrote:
> > > On Tue, Sep 11, 2012 at 11:47:02AM +0300, Dan Carpenter wrote:
> > > > > +static int tpci200_get_clockrate(struct ipack_device *dev)
> > > > > +{
> > > > > +	struct tpci200_board *tpci200 = check_slot(dev);
> > > > > +	__le16 __iomem *addr;
> > > > 
> > > > The point of the underscores in the __le16 is that you don't want to
> > > > pollute user space headers in glibc with a bunch of kernel typedefs.
> > > > It is not needed here.  (Or if it is, then we would need to replace
> > > > the u16 uses as well).
> > > 
> > > I was under the impression that "__le16" is used to indicate the
> > > byteorder of the pointed to memory.  As far as I can see that
> > > information is lost when we use u16.  Am I missing something?
> > > 
> > 
> > Use the no-underscore version unless it's inside a header which is
> > exported to userspace.
> > 
> > 	le16 __iomem *addr;
> > 
> 
> But it is not declared in linux/types, it is?
> 
> I have found only this typedef in a quick search:
> 
> http://lxr.linux.no/#linux+v3.5.3/fs/ntfs/types.h#L28
> 
> Should we define them in ipack.h header file or they are defined in
> other place?
> 

Oh crap!  You're right.  That's embarrassing.  I'm just totally
wrong here.  Sorry for that.

regards,
dan carpenter

