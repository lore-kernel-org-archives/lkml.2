Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab2ILLOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:14:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20711 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2ILLOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:14:04 -0400
Date: Wed, 12 Sep 2012 14:13:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new
 callbacks to tpci200
Message-ID: <20120912111330.GD19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-3-git-send-email-siglesias@igalia.com>
 <20120911084702.GM19396@mwanda>
 <20120912092833.GA24558@endeavour.taprogge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912092833.GA24558@endeavour.taprogge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 11:28:33AM +0200, Jens Taprogge wrote:
> On Tue, Sep 11, 2012 at 11:47:02AM +0300, Dan Carpenter wrote:
> > > +static int tpci200_get_clockrate(struct ipack_device *dev)
> > > +{
> > > +	struct tpci200_board *tpci200 = check_slot(dev);
> > > +	__le16 __iomem *addr;
> > 
> > The point of the underscores in the __le16 is that you don't want to
> > pollute user space headers in glibc with a bunch of kernel typedefs.
> > It is not needed here.  (Or if it is, then we would need to replace
> > the u16 uses as well).
> 
> I was under the impression that "__le16" is used to indicate the
> byteorder of the pointed to memory.  As far as I can see that
> information is lost when we use u16.  Am I missing something?
> 

Use the no-underscore version unless it's inside a header which is
exported to userspace.

	le16 __iomem *addr;

regards,
dan carpenter

