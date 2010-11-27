Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0K0S5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 13:57:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab0K0S5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 13:57:45 -0500
Date: Sat, 27 Nov 2010 10:58:29 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Richardson <mcr@sandelman.ca>
Cc: linux-kernel@vger.kernel.org, bart@jukie.net
Subject: Re: odd behavior from /sys/block (sysfs)
Message-ID: <20101127185829.GA19708@suse.de>
References: <5108.1290796566@marajade.sandelman.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5108.1290796566@marajade.sandelman.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 01:36:06PM -0500, Michael Richardson wrote:
> 
> {please CC me}
> 
> I was capturing data from my laptop's /sys file system as test input
> for some code that needs to grovel through /sys a bit.  I found it weird
> that tar got different answers than ls!  See below (at end) for original
> observation.
> 
> It seems that this is because lstat64() on sysfs returns st_size=0 for
> the link, and tar does not know how to deal with this, while ls does.
> I don't know if it is tar that is wrong, or sysfs.
> lstat64(3) suggests that it is sysfs that is at fault, that it should
> set st_size.  The behaviour of ls, suggests that perhaps other systems
> have worked around st_size=0 for symlinks.  (I'm on 2.6.32-bpo.5 from debian)

So, what do you think should be changed here?

I wouldn't ever recommend using tar on sysfs as it doesn't make any
sense (sysfs is a virtual file system, like /proc/ and I think that tar
doesn't like /proc either, right?)

thanks,

greg k-h
