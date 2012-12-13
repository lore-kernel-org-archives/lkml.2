Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2LMAJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:09:02 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:50675 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LMAJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:09:01 -0500
Date: Thu, 13 Dec 2012 01:08:54 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Benedikt Spranger <b.spranger@linutronix.de>,
        "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 2/2] uio: do not expose inode to uio open/release hooks
Message-ID: <20121213000853.GD4261@local>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
 <1355267523-19724-3-git-send-email-b.spranger@linutronix.de>
 <20121211232032.GA24933@kroah.com>
 <20121212014221.GA2642@local>
 <20121212044648.GB7224@kroah.com>
 <20121212085053.GF2642@local>
 <20121212095616.357a59e9@mitra.spranger.biz>
 <20121212150818.GB8449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212150818.GB8449@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 07:08:18AM -0800, Greg KH wrote:
> On Wed, Dec 12, 2012 at 09:56:16AM +0100, Benedikt Spranger wrote:
> > Am Wed, 12 Dec 2012 09:50:54 +0100
> > schrieb "Hans J. Koch" <hjk@hansjkoch.de>:
> > 
> > > On Tue, Dec 11, 2012 at 08:46:48PM -0800, Greg KH wrote:
> > > > Yes, but what does that have to do with this in-kernel, internal api?
> > > 
> > > Ah, OK. You're right, the commit message is confusing.
> > > 
> > > Bene, it's enough to say we drop the inode parameter because nobody
> > > ever needed it.
> > I am fine with that.
> > 
> > > I cannot see why this also helps with the other problem.
> > It would help, because we can defer calling the release hook until the
> > last mmap user is gone. In this case the inode pointer may not be valid
> > anymore.
> 
> Which, again, is the same for any in-kernel driver with these types of
> callbacks.

Is that a general mmap problem that wants to be fixed?

hjk

> 
> greg k-h
> 
