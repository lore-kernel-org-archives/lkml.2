Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2DGBPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:15:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2DGBPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:15:03 -0400
Date: Sat, 7 Apr 2012 03:14:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
In-Reply-To: <1333760371.8565.19.camel@joe2Laptop>
Message-ID: <alpine.LNX.2.00.1204070303370.24006@pobox.suse.cz>
References: <1333569554.864.3.camel@mop>  <alpine.LRH.2.00.1204070222130.18937@twin.jikos.cz> <1333760371.8565.19.camel@joe2Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Joe Perches wrote:

> > > - Output of dev_printk() is reliably machine-readable now. In addition
> > >   to the printed plain text message, it creates a log dictionary with the
> > >   following properties:
> > >     SUBSYSTEM=     - the driver-core subsytem name
> > >     DEVICE=
> > >       b12:8        - block dev_t
> > >       c127:3       - char dev_t
> > >       n8           - netdev ifindex
> > >       +sound:card0 - subsystem:devname
> > 
> > One of the questions that hasn't been raised yet, and which I personally 
> > consider crucial -- are we making printk() interface part of userspace ABI 
> > now by this?
> 
> I hope not.

And how exactly do we prevent that? It's a systematic and well-defined 
interface between kernel and userspace, and as such it's hard to not 
consider it to be ABI.

> > Today, we are free to change any printk()s and not feel guilty about it at 
> > all. With this, we are making the whole thing much more systematic and 
> > friendly for automatic userspace consumption.
> 
> It _may_ be that new KEYWORD=VALUE combinations may become systematic 
> and an ABI, but the content of the message is still arbitrary and should 
> be designated as changeable without notice.

I bet there would be "you broke my userspace app because it was depending 
on the printk() you just removed" bugreport coming from someone very soon. 

We can then either start explaining why this structured and well-defined 
printk() is not ABI, or just don't allow for that to happen in the first 
place by keeping printk() what it has always been -- unstructured linear 
flow of log entries destined only to be read by humans.

-- 
Jiri Kosina
SUSE Labs
