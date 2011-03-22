Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab1CVXOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:14:18 -0400
Received: from kroah.org ([198.145.64.141]:34874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1CVXOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:14:16 -0400
Date: Tue, 22 Mar 2011 15:30:13 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>
Subject: Re: Standard handling of boolean attributes in sysfs.
Message-ID: <20110322223013.GB31312@kroah.com>
References: <4D87AEE0.8000807@cam.ac.uk>
 <20110321201411.GA1704@kroah.com>
 <4D88811F.7060901@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D88811F.7060901@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:59:43AM +0000, Jonathan Cameron wrote:
> On 03/21/11 20:14, Greg KH wrote:
> > On Mon, Mar 21, 2011 at 08:02:40PM +0000, Jonathan Cameron wrote:
> >> Hi All,
> >>
> >> Just wondering what the feeling would be about having
> >> a utility function similar to sysfs_streq to provide a
> >> consistent option for all those sysfs attributes out there
> >> where
> >>
> >> 1, on, true -> 1
> >> 0, off, false -> 0
> >>
> >> Or does such a beast already exist and I'm just being unobservant?
> > 
> > We have the one in debugfs that I think people use for sysfs.  Have you
> > looked at that?
> > 
> Thanks for the pointer...
> 
> write_file_bool in fs/debugfs/file.c?  
> 
> What is there is pretty much what is needed, but it's not a general
> use function like sysfs_streq. Clearly it would make sense to use
> what is there as a basis of such a function. 
> 
> To save others looking it up, the relevant bit is:
> 
> 	switch (buf[0]) {
> 	case 'y':
> 	case 'Y':
> 	case '1':
> 		*val = 1;
> 		break;
> 	case 'n':
> 	case 'N':
> 	case '0':
> 		*val = 0;
> 		break;
> 	}
> 
> There are a few cut and paste copies of this about (mostly in IIO drivers actually
> hence why I asking if there is a better way :).
> 
> Unless there is demand for it elsewhere I'll just add a utility function to the IIO
> core to do this and we can revisit the case for a general function when the need
> turns up elsewhere.

The other function that does this, and is what I was thinking of, is
param_set_bool().  Care to merge both of these functions together into
something "sane" and have everyone use it?

thanks,

greg k-h
