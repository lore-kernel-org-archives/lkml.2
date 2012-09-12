Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab2ILL65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:58:57 -0400
Received: from shamrock.taprogge.org ([213.146.117.139]:57831 "EHLO
	shamrock.taprogge.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab2ILL64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:58:56 -0400
Date: Wed, 12 Sep 2012 13:58:41 +0200
From: Jens Taprogge <jens.taprogge@taprogge.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new
 callbacks to tpci200
Message-ID: <20120912115841.GA32074@endeavour.taprogge.org>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-3-git-send-email-siglesias@igalia.com>
 <20120911084702.GM19396@mwanda>
 <20120912092833.GA24558@endeavour.taprogge.org>
 <20120912111330.GD19396@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912111330.GD19396@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Anti-Spam: Skipped scanning; message comes from a trusted host.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:13:30PM +0300, Dan Carpenter wrote:
> On Wed, Sep 12, 2012 at 11:28:33AM +0200, Jens Taprogge wrote:
> > On Tue, Sep 11, 2012 at 11:47:02AM +0300, Dan Carpenter wrote:
> > > > +static int tpci200_get_clockrate(struct ipack_device *dev)
> > > > +{
> > > > +	struct tpci200_board *tpci200 = check_slot(dev);
> > > > +	__le16 __iomem *addr;
> > > 
> > > The point of the underscores in the __le16 is that you don't want to
> > > pollute user space headers in glibc with a bunch of kernel typedefs.
> > > It is not needed here.  (Or if it is, then we would need to replace
> > > the u16 uses as well).
> > 
> > I was under the impression that "__le16" is used to indicate the
> > byteorder of the pointed to memory.  As far as I can see that
> > information is lost when we use u16.  Am I missing something?
> > 
> 
> Use the no-underscore version unless it's inside a header which is
> exported to userspace.
> 
> 	le16 __iomem *addr;
> 
> regards,
> dan carpenter

Doing a quick
  grep " le16 "
in drivers I have not found a single occurance that is not within 
a comment.  There are plenty of __le16 occurances though.

Best Regards,
Jens
