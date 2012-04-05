Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2DEAbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:31:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37602 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753898Ab2DEAbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:31:44 -0400
X-Sasl-enc: Zo+ENQgdqUNyqXDUIxWt4gRVBKqlylQvceH2sFNL6yyo 1333585904
Date: Wed, 4 Apr 2012 17:31:42 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
Message-ID: <20120405003142.GA27595@kroah.com>
References: <1333569554.864.3.camel@mop>
 <20120404210507.GA1716@kroah.com>
 <CAPXgP13mvFNphitrtXnsj+c3+GYvSPU=2-HgtKbHGhmz-CE68g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP13mvFNphitrtXnsj+c3+GYvSPU=2-HgtKbHGhmz-CE68g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 11:14:25PM +0200, Kay Sievers wrote:
> On Wed, Apr 4, 2012 at 23:05, Greg Kroah-Hartmann <greg@kroah.com> wrote:
> > On Wed, Apr 04, 2012 at 09:59:14PM +0200, Kay Sievers wrote:
> 
> >> - Output of dev_printk() is reliably machine-readable now. In addition
> >>   to the printed plain text message, it creates a log dictionary with the
> >>   following properties:
> >>     SUBSYSTEM=     - the driver-core subsytem name
> >>     DEVICE=
> >>       b12:8        - block dev_t
> >>       c127:3       - char dev_t
> >>       n8           - netdev ifindex
> >>       +sound:card0 - subsystem:devname
> >
> > I like this a lot, thanks for doing this.
> >
> > Is there somewhere in Documentation/ABI that we can document this
> > interface so that people know what it is, what is defined, and how to
> > use it?
> 
> It's the notation udev uses to identify its devices internally. I just
> added the above description to the source code so far. If we agree on
> that, or some other scheme, we should definitely copy that into the
> ABI docs. Along with a description of the semantics of the chardev
> regarding open() poll() and seek().

Ok, that sounds good.  I like the description, and implementation, so I
have no objections to this patch, I'd be glad to queue it up through my
tree to get testing in linux-next now if you want.

> >> - Support for multiple concurrent readers of /dev/kmsg, with read(),
> >>   seek(), poll() support. Output of message sequence numbers, to allow
> >>   userspace log consumers to reliably reconnect and reconstruct their
> >>   state at any given time. After open("/dev/kmsg"), read() always
> >>   returns *all* buffered records. If only future messages should be
> >>   read, SEEK_END can be used. In case records get overwritten while
> >>   /dev/kmsg is held open, or records get faster overwritten than they
> >>   are read, the next read() will return -EPIPE and the current reading
> >>   position gets updated to the next available record. The passed
> >>   sequence numbers allow the log consumer to calculate the amount of
> >>   lost messages.
> >
> > I just noticed that 'tail -f' doesn't seem to work on /dev/kmsg, should
> > it?  Or does it need to do something else to get "just the new ones"?
> 
> Yeah, 'tail' might not work, it expects a regular file. This is a
> chardev and it has not the regular file semantics which 'tail'
> expects; 'cat' should work fine. 'Real' tools will just use poll() to
> know when to get new messages out of the file descriptor.

Ah, you are right, I forgot about the "real file" stuff with tail, the
device node never gets updated with a timestamp.

thanks,

greg k-h
