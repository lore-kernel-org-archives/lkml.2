Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0EROCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:02:39 -0400
Received: from kroah.org ([198.145.64.141]:38480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733Ab0EROCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:02:31 -0400
Date: Tue, 18 May 2010 07:02:26 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Chris Wright <chrisw@sous-sol.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100518140226.GB24113@kroah.com>
References: <20100518164409.8b19c786.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518164409.8b19c786.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:44:09PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> cc1: warnings being treated as errors
> In file included from include/linux/kobject.h:21,
>                  from include/linux/device.h:17,
>                  from arch/powerpc/lib/devres.c:10:
> include/linux/sysfs.h:97: error: 'struct file' declared inside parameter list
> include/linux/sysfs.h:97: error: its scope is only this definition or declaration, which is probably not what you want
> include/linux/sysfs.h:99: error: 'struct file' declared inside parameter list
> include/linux/sysfs.h:101: error: 'struct file' declared inside parameter list
> 
> and many more (arch/powerpc is built with -Werror (as do some other
> architectures)) and lots of similar warnings ...
> 
> Caused by commit f8e898186196a22756b50b908ecd92123265f8a2 ("sysfs: add
> struct file* to bin_attr callbacks").   See Rule 1 in
> Documentation/SubmitChecklist.  The header file probably just needs
> "struct file;" added in the right place.
> 
> I have reverted that commit for today (and commit
> 44e425ab9f887ec6d3a7a4481f3b0c99f120de19 ("pci: check caps from sysfs
> file open to read device dependent config space") that depends on it).

Ick.

Chris, care to send a patch to resolve this?

thanks,

greg k-h
