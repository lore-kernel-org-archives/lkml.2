Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2GRWWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:22:14 -0400
Received: from longford.logfs.org ([213.229.74.203]:43552 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2GRWWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:22:12 -0400
Date: Wed, 18 Jul 2012 17:08:15 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120718210814.GA1871@logfs.org>
References: <20120424205946.GH20610@logfs.org>
 <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
 <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
 <20120718185335.GA1771@logfs.org>
 <20120718214520.GA14067@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120718214520.GA14067@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 July 2012 23:45:21 +0200, Borislav Petkov wrote:
> 
> > > So why is that first megabyte full of zeros there?
> > 
> > It gives you some scratch space to store information in.
> 
> How? By me writing something in that empty line in vim? Or something
> else storing stuff there?

Assuming you want to do it in an automated fashion - by patching or
replacing mkblockconsole.  Again, I have no opinion on whether this
actually makes sense.  It is possible, it does not really hurt the
primary function and people have explicitly asked me for it.  Good
enough for me.

> > How useful that actually is may be a matter of opinion. But
> > independent of that, you will find large amounts of zeroes all over.
> > Every time you reboot, the new blockconsole will start writing at a
> > megabyte-aligned offset and whatever remains of the last megabyte
> > should be zero-filled as well.
> 
> Ah, those are the tiles you're talking about in the docs, right?

Yes.

> Oh, I didn't mean anything involved but rather a quick steps write-up
> (steps can always be expanded and made more verbose later):
> 
> Blocksonsole in three easy steps
> ================================
> 
> 1. Find an unused USB stick and prepare it for blockconsole by writing
> the blockconsole signature to it:
> 
> $ ./mkblockconsole /dev/sdc
> 
>   [ Assuming /dev/sdc is the device node of the USB stick you just mounted. ]
> 
> 2. USB stick is ready for use, replug it so that the kernel can start
> logging to it.
> 
> 3. After you've done logging, read out the logs from it like this:
> 
> $ ./bcon_tail
> 
>   [ This creates a file called /var/log/bcon.<random number> which
>   contains the logs. Open it with a sane editor like vim which can
>   display zeroed gaps as a single line and start staring at the logs. ]

Or show off your geekiness by using back ticks:
$ vi `./bcon_tail`

> Something like the above, just slap it at the beginning of
> Documentation/block/blockconsole.txt for impatient people like me and
> that's it :-).

Will do.

Jörn

--
There's nothing better for promoting creativity in a medium than
making an audience feel "Hmm ­ I could do better than that!"
-- Douglas Adams in a slashdot interview
