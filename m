Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab1D3Pe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 11:34:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab1D3Pe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 11:34:56 -0400
Date: Sat, 30 Apr 2011 08:34:52 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-ID: <20110430153452.GA21439@suse.de>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
 <20110429162817.2eb26efb.akpm@linux-foundation.org>
 <20110430112937.06024368@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430112937.06024368@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 11:29:37AM +0100, Alan Cox wrote:
> On Fri, 29 Apr 2011 16:28:17 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 29 Apr 2011 00:24:29 +0200
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > Allow setting of maximal number of raw devices as a module parameter. This
> > > requires changing of static array into a vmalloced one (the array is going to
> > > be too large for kmalloc).
> 
> A large vmalloc array is very antisocial on a 32bit x86 box. It looks
> like almost all of it would become sane if there was an array of pointers
> to raw devices and the devices were initially allocated on need (even if
> for now only recovered on rmmod)

In practice, we've never seen a problem with this[1].  Machines that
want thousands of raw devices have plenty of memory to handle this
situation.

I doubt adding the complexity of dynamically allocating the devices
as-needed is worth it for the very few systems that ever use this
driver, compounded with the fact that we keep saying that this code
isn't to be used by "normal" people anyway.

thanks,

greg k-h

[1] Again, this has been shipping for years in SLES kernels with no
reported bug reports.  I know that's not really a valid reason to do
things, but it is a data point for the simplicity of this patch.
