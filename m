Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0K3RhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:37:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab0K3RhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:37:01 -0500
Date: Tue, 30 Nov 2010 09:36:50 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Richardson <mcr@sandelman.ca>
Cc: linux-kernel@vger.kernel.org, bart@jukie.net
Subject: Re: odd behavior from /sys/block (sysfs)
Message-ID: <20101130173650.GA19785@suse.de>
References: <5108.1290796566@marajade.sandelman.ca>
 <20101127185829.GA19708@suse.de>
 <4605.1290892451@marajade.sandelman.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4605.1290892451@marajade.sandelman.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 04:14:11PM -0500, Michael Richardson wrote:
> 
> >>>>> "Greg" == Greg KH <gregkh@suse.de> writes:
>     >> {please CC me}
>     >> 
>     >> I was capturing data from my laptop's /sys file system as test input
>     >> for some code that needs to grovel through /sys a bit.  I found it weird
>     >> that tar got different answers than ls!  See below (at end) for original
>     >> observation.
>     >> 
>     >> It seems that this is because lstat64() on sysfs returns st_size=0 for
>     >> the link, and tar does not know how to deal with this, while ls does.
>     >> I don't know if it is tar that is wrong, or sysfs.
>     >> lstat64(3) suggests that it is sysfs that is at fault, that it should
>     >> set st_size.  The behaviour of ls, suggests that perhaps other systems
>     >> have worked around st_size=0 for symlinks.  (I'm on 2.6.32-bpo.5
>     >> from debian) 
> 
>     Greg> So, what do you think should be changed here?
> 
> Iif st_size=0 is not a valid return from readlink(2), then I think sysfs
> should be fixed.    I will cook a patch.
> 
> While tar might not useful (I was successful at using cp -r, btw),
> having working file operations makes sense. 

I agree, a patch would be most welcome.

>     Greg> I wouldn't ever recommend using tar on sysfs as it doesn't make any
>     Greg> sense (sysfs is a virtual file system, like /proc/ and I think
>     Greg> that tar doesn't like /proc either, right?)
> 
> Are there things on /sys for which a read is not idempotent?

There might be some binary files in /sys where this does not happen.

Also note that other filesystems are mounted under /sys, like debugfs
which is in /sys/kernel/debug/ and all bets are off as to what are in
those files and if they ever terminate :)

thanks,

greg k-h
