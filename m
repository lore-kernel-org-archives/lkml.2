Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1EDS3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:29:03 -0400
Received: from kroah.org ([198.145.64.141]:49469 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab1EDS3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:29:01 -0400
Date: Wed, 4 May 2011 11:28:55 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: various vmbus review comments
Message-ID: <20110504182855.GB8911@kroah.com>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFD6B@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DFD6B@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 04:58:39PM +0000, KY Srinivasan wrote:
> > > 2) hyperv_storage.h - this has all the definitions needed to build storage
> > > drivers for Hyper-V. Storage drivers will include hyperv.h and
> > > hyperv_storage.h.
> > >
> > > 3) hyperv_net.h - this has all the definitions needed to build the network
> > > driver for Hyper-V. The netvsc driver will include hyperv.h and hyperv_net.h.
> > >
> > > 4) hyperv_utils.h - this has all the definitions needed to build the util driver.
> > > The util driver would include hyperv.h and hyperv_utils.h.
> > 
> > No for all 3 of these.  Why would a simple driver need a .h file at all?
> > Just include the structures within the .c file, making it nice and
> > self-contained.  There's no need to clutter things up, and individual
> > driver .h files should _never_ be in include/linux.
> 
> Agreed - we don't need to clutter up  include/linux directory with individual
> driver.h files. However, including all the definitions in the .c file would also be
> ugly. For instance there are multiple *.c files for the storage drivers and we don't
> want to replicate the contents of  hyperv_storage.h in each of these .c files.
> The same is true for the netvsc driver - there are multiple .c files where we would need
> to replicate the contents of hyperv_net.h. 
> 
> How about I keep these driver specific header files; but these could be local to the 
> directory where these drivers land.

Yes, that is fine.  I still find it odd that you need multiple files for
the network driver.  We have much more complex and longer drivers for
common cards these days than this one, all in one file.  But that's for
you and the network developers to argue over :)

thanks,

greg k-h
