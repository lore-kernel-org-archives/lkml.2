Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2DGBvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:51:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46544 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752765Ab2DGBvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:51:12 -0400
Message-ID: <1333763471.8565.32.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 06 Apr 2012 18:51:11 -0700
In-Reply-To: <alpine.LNX.2.00.1204070303370.24006@pobox.suse.cz>
References: <1333569554.864.3.camel@mop>
	 <alpine.LRH.2.00.1204070222130.18937@twin.jikos.cz>
	 <1333760371.8565.19.camel@joe2Laptop>
	 <alpine.LNX.2.00.1204070303370.24006@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-07 at 03:14 +0200, Jiri Kosina wrote:
> On Fri, 6 Apr 2012, Joe Perches wrote:
> 
> > > > - Output of dev_printk() is reliably machine-readable now. In addition
> > > >   to the printed plain text message, it creates a log dictionary with the
> > > >   following properties:
> > > >     SUBSYSTEM=     - the driver-core subsytem name
> > > >     DEVICE=
> > > >       b12:8        - block dev_t
> > > >       c127:3       - char dev_t
> > > >       n8           - netdev ifindex
> > > >       +sound:card0 - subsystem:devname
> > > 
> > > One of the questions that hasn't been raised yet, and which I personally 
> > > consider crucial -- are we making printk() interface part of userspace ABI 
> > > now by this?
> > 
> > I hope not.
> 
> And how exactly do we prevent that? It's a systematic and well-defined 
> interface between kernel and userspace, and as such it's hard to not 
> consider it to be ABI.
> 
> > > Today, we are free to change any printk()s and not feel guilty about it at 
> > > all. With this, we are making the whole thing much more systematic and 
> > > friendly for automatic userspace consumption.
> > 
> > It _may_ be that new KEYWORD=VALUE combinations may become systematic 
> > and an ABI, but the content of the message is still arbitrary and should 
> > be designated as changeable without notice.
> 
> I bet there would be "you broke my userspace app because it was depending 
> on the printk() you just removed" bugreport coming from someone very soon. 
> 
> We can then either start explaining why this structured and well-defined 
> printk() is not ABI, or just don't allow for that to happen in the first 
> place by keeping printk() what it has always been -- unstructured linear 
> flow of log entries destined only to be read by humans.

I think the commit log is poor.

printk() is effectively unmodified.

Generic helpers like dev_printk() can have an extra bit
prepended in the form of device/class/name.

All dev_printk device/class/name does is show what device
emitted a message.  It doesn't limit the message content.
The content of the message after that device/class/name
is still arbitrary.

No other use has been proposed, that's why I think it's
not all that valuable (yet?).

I do think that printk_emit, which I think is a bad name,
( maybe printk_tva() or printk_desc() ) has some value.

The record oriented change also has value as it can more
easily be optionally extended to compress/decompress the
text message to save memory space per record.  Of course
that'd only be valuable when CONFIG_LOG_BUF_SHIFT is
large enough to gain something by using compression.


