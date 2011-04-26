Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab1DZAp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:45:28 -0400
Received: from kroah.org ([198.145.64.141]:39972 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab1DZApX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:45:23 -0400
Date: Mon, 25 Apr 2011 17:40:05 -0700
From: Greg KH <greg@kroah.com>
To: "Mark A. Allyn" <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        jayant.mangalampalli@intel.com, venkat.r.gokulrangan@intel.com
Subject: Re: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Message-ID: <20110426004005.GA29534@kroah.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 02:29:35PM -0700, Mark A. Allyn wrote:
> Sorry, I had an incorrect return address config in alpine. . .
> 
> What else needs to be done to the sep driver in order for it to be
> moved to the kernel from staging?

Some things at first glance:
	- you have a lot of ioctls, do you really need them all?
	- your ioctls use structures with very "generic" names, please
	  prefix them with "sep_" as you are joining the global
	  namespace here.
	- sep_driver_api.h seems to have a lot of information in it that
	  doesn't need to be there (i.e. move it to a private .h file.)
	- is there documentation for how to use this device through the
	  ioctls anywhere?
	- are you sure your ioctl magic number isn't already reserved by
	  some other driver?
	- the structures you use for the ioctls, shouldn't they use the
	  correct "__" prefixes on their type?  How about 64/32 bit
	  thunking layer, isn't that needed?
	- you have a number of basic checkpatch formatting issues to fix
	  up, please do so.
	- do you really even need all of the .h files you have?  Can't
	  they just go into the .c file?
	- sep_wait_sram_write() has no way to abort, if the hardware
	  hangs, you just locked up your kernel :(

that's good for a first round of review, right?

thanks,

greg k-h
