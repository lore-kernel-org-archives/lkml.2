Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1AZCxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 21:53:01 -0500
Received: from kroah.org ([198.145.64.141]:52903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab1AZCw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 21:52:56 -0500
Date: Wed, 26 Jan 2011 10:47:29 +0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 0/6] google firmware support
Message-ID: <20110126024729.GC28283@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125030105.GA8761@kroah.com>
 <AANLkTim_KmmtAULeeBBsoz_BkxhbQLg24PK_pfPQiLtE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim_KmmtAULeeBBsoz_BkxhbQLg24PK_pfPQiLtE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:58:27AM -0800, Mike Waychison wrote:
> On Mon, Jan 24, 2011 at 7:01 PM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Jan 24, 2011 at 04:24:34PM -0800, Mike Waychison wrote:
> >>
> >>    - [5] prepares for [6] by introducing prepend_to_dmesg() which
> >>      allows drivers to prepend pre-kernel messages to the dmesg at
> >>      bootup.
> >
> > That seems "rude".  Why can't you just pick out from the kernel log the
> > data you need when it gets printed?  This seems like you feel your code
> > should always get a "First Post!" message.
> 
> Well, the use case we have is that we prepend all the bios output (and
> anything emitted by option roms and boot loaders via int 10h).  This
> typically runs in the 100+ lines of output.
> 
> Basically, everything the user sees on the console after power up is
> available to him in the dmesg.  We did this out of convenience as it
> makes for a good looking log :)

That's a nice goal, but I don't think the kernel log is the proper place
for this.

> That said, it's dmesg, and we don't build automation on anything in
> there if we can help it.  I can move this memory console dump
> elsewhere (/sys/firmware/log ?)

Yes, /sys/firmware/log would be a great place for it.  Make it a binary
sysfs file, and just dump the firmware data right into it, not having
the kernel do anything with it at all.

Oh, and document the thing in Documentation/ABI please, so that other
platforms can take advantage of this interface as well in the future.

nice idea,

greg k-h
