Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0GGQjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 12:39:37 -0400
Received: from fieldses.org ([174.143.236.118]:46208 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab0GGQjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 12:39:36 -0400
Date: Wed, 7 Jul 2010 12:39:19 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, neilb@suse.de, david@fromorbit.com,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100707163919.GA28815@fieldses.org>
References: <20100706232351.GD25018@dastard>
 <20100707093629.10c2feab@notabene.brown>
 <20100707021150.GF25018@dastard>
 <20100707125726.3695587a@notabene.brown>
 <20100707125701.GA19872@fieldses.org>
 <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu>
 <20100707131721.GB19872@fieldses.org>
 <E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu>
 <20100707144511.GA24360@fieldses.org>
 <877hl7fdzw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hl7fdzw.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 10:03:39PM +0530, Aneesh Kumar K. V wrote:
> On Wed, 7 Jul 2010 10:45:11 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > On Wed, Jul 07, 2010 at 03:35:50PM +0200, Miklos Szeredi wrote:
> > > On Wed, 7 Jul 2010, J. Bruce Fields wrote:
> > > > > > If you use sys or proc, is it possible to get the uuid from a file
> > > > > > descriptor or pathname without races?
> > > > > 
> > > > > You can do stat/fstat to find out the device number (which is unique,
> > > > > but not persistent)
> > > > 
> > > > Is it really unique over time? (Can't a given st_dev value map to one
> > > > filesystem now, and another later?) 
> > > 
> > > It's unique at a single point in time.  But if you have a reference
> > > (e.g. open file descriptor) on the mount then that's not a problem.
> > > 
> > >    fd = open(path, ...);
> > >    fstat(fd, &st);
> > >    search st.st_dev in mountinfo
> > >    close(fd)
> > > 
> > > is effectively the same as an getuuid(path) syscall (lazy unmounted
> > > filesystems will not be found in mountinfo, but the reference is still
> > > there so st_dev will not be reused for other filesystems).
> > 
> > OK, cool.
> > 
> > That still leaves the problem that there isn't always an underlying
> > block device, and/or when there is it doesn't always uniquely specify
> > the filesystem.
> > 
> 
> And for this reason we would need this as a syscall right ?

That's the only solution I see.  (Or use an xattr?)

--b.
