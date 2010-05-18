Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0ERVGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:06:16 -0400
Received: from sous-sol.org ([216.99.217.87]:38213 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752380Ab0ERVGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:06:15 -0400
Date: Tue, 18 May 2010 14:06:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Chris Wright <chrisw@sous-sol.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100518210607.GI8301@sequoia.sous-sol.org>
References: <20100518164409.8b19c786.sfr@canb.auug.org.au>
 <20100518140226.GB24113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518140226.GB24113@kroah.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Tue, May 18, 2010 at 04:44:09PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the driver-core tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > cc1: warnings being treated as errors
> > In file included from include/linux/kobject.h:21,
> >                  from include/linux/device.h:17,
> >                  from arch/powerpc/lib/devres.c:10:
> > include/linux/sysfs.h:97: error: 'struct file' declared inside parameter list
> > include/linux/sysfs.h:97: error: its scope is only this definition or declaration, which is probably not what you want
> > include/linux/sysfs.h:99: error: 'struct file' declared inside parameter list
> > include/linux/sysfs.h:101: error: 'struct file' declared inside parameter list
> > 
> > and many more (arch/powerpc is built with -Werror (as do some other
> > architectures)) and lots of similar warnings ...
> > 
> > Caused by commit f8e898186196a22756b50b908ecd92123265f8a2 ("sysfs: add
> > struct file* to bin_attr callbacks").   See Rule 1 in
> > Documentation/SubmitChecklist.  The header file probably just needs
> > "struct file;" added in the right place.
> > 
> > I have reverted that commit for today (and commit
> > 44e425ab9f887ec6d3a7a4481f3b0c99f120de19 ("pci: check caps from sysfs
> > file open to read device dependent config space") that depends on it).
> 
> Ick.
> 
> Chris, care to send a patch to resolve this?

Would you prefer incremental to fold in, or respin?  It's just this
one-liner fwd declaration as Stephen mentioned.

thanks,
-chris
