Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161329Ab2COTsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:48:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47953 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032188Ab2COTsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:48:30 -0400
Date: Thu, 15 Mar 2012 12:48:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Clark, Liz" <liz.clark@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TTY: Wrong unicode value copied in con_set_unimap()
Message-ID: <20120315194826.GA17918@kroah.com>
References: <1331832809-4484-1-git-send-email-liz.clark@hp.com>
 <20120315185514.GB11142@kroah.com>
 <51D3961FBAB878428126A3DD5A715A3A60EA9094CE@GVW1338EXA.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D3961FBAB878428126A3DD5A715A3A60EA9094CE@GVW1338EXA.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 07:36:34PM +0000, Clark, Liz wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, March 15, 2012 11:55 AM
> > To: Clark, Liz
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] TTY: Wrong unicode value copied in
> > con_set_unimap()
> > 
> > On Thu, Mar 15, 2012 at 10:33:29AM -0700, Liz Clark wrote:
> > > Bugzilla 40012: PIO_UNIMAP bug: error updating Unicode-to-font map
> > >
> > > The unicode font map for the virtual console is a 32x32x64 table
> > which
> > > allocates rows dynamically as entries are added.  The unicode value
> > > increases sequentially and should count all entries even in empty
> > > rows.  The defect is when copying the unicode font map in
> > con_set_unimap(),
> > > the unicode value is not incremented properly.  The wrong unicode
> > value
> > > is entered in the new font map.
> > >
> > > Signed-off-by: Liz Clark <liz.clark@hp.com>
> > 
> > Is this a new problem caused by recent changes in this area, or has it
> > always been there and needs to be backported to older kernels to solve
> > the problem there?
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> The code with the defect was introduced in v2.1.112.  Prior to that
> the fontmap was not copied at all in con_set_unimap().

Ok, as this has been with us for a few years, it can wait for 3.4 to go
in, and I'll mark it for stable to get it applied backwards as far as it
can go.

thanks,

greg k-h
