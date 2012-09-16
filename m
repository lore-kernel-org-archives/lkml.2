Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2IPQhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 12:37:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37512 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2IPQhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 12:37:08 -0400
Date: Sun, 16 Sep 2012 09:37:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
        Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
Subject: Re: [ 16/46] NFSv4.1: Remove a bogus BUG_ON() in
 nfs4_layoutreturn_done
Message-ID: <20120916163703.GA7871@kroah.com>
References: <20120912233817.662663809@linuxfoundation.org>
 <20120912233819.364182315@linuxfoundation.org>
 <1347813183.13258.286.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347813183.13258.286.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 05:33:03PM +0100, Ben Hutchings wrote:
> On Wed, 2012-09-12 at 16:39 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > 
> > commit 47fbf7976e0b7d9dcdd799e2a1baba19064d9631 upstream.
> > 
> > Ever since commit 0a57cdac3f (NFSv4.1 send layoutreturn to fence
> > disconnected data server) we've been sending layoutreturn calls
> > while there is potentially still outstanding I/O to the data
> > servers. The reason we do this is to avoid races between replayed
> > writes to the MDS and the original writes to the DS.
> > 
> > When this happens, the BUG_ON() in nfs4_layoutreturn_done can
> > be triggered because it assumes that we would never call
> > layoutreturn without knowing that all I/O to the DS is
> > finished. The fix is to remove the BUG_ON() now that the
> > assumptions behind the test are obsolete.
> > 
> > Reported-by: Boaz Harrosh <bharrosh@panasas.com>
> > Reported-by: Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [...]
> 
> The upstream commit has:
> 
>     Cc: stable@vger.kernel.org [>=3.5]
> 
> and so I ignored it for 3.2.  Is it actually needed for the earlier
> stable series?

Crud, I missed that somehow :(

Trond, should I revert this in 3.0 and 3.4 stable kernels?

thanks,

greg k-h
