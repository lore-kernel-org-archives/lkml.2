Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab2FOAEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:04:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46836 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab2FOAE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:04:27 -0400
Date: Thu, 14 Jun 2012 17:04:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120615000422.GA8591@kroah.com>
References: <1336004953.4240.9.camel@mop>
 <20120526111143.GA32304@lizard>
 <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
 <1338307620.886.21.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338307620.886.21.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:07:00PM +0200, Kay Sievers wrote:
> On Sun, 2012-05-27 at 16:23 +0200, Kay Sievers wrote:
> > On Sat, May 26, 2012 at 1:11 PM, Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> 
> > > So, starting from this patch every kmsg_dump user is getting the
> > > binary stuff, which is barely usable, and breaks a longstanding
> > > user-visible ABIs (e.g. mtdoops, oops dumping into nvram on PowerPC,
> > > and ramoops of course).
> > 
> > These cases export their own format, it's just that the dump routines
> > could copy the buffer in only two steps (beginning and end of the ring
> > buffer), while in the future their code would need an update to copy
> > it record for record now. The exported format in the dump does not
> > necessarily need to change.
> 
> Here is an untested patch, which should restore the old plain text
> export format of the kmsg buffer. I adds an iterator to the dumper
> routine, which can be used by the dumper to properly copy the data out
> of the kmsg record buffer. All current users are converted in the same
> patch.
> 
> Any feedback/help in testing/updating and getting this thing into a
> mergeable state would be greatly appreciated.
> 
> There are two versions of the iterator:
> kmsg_dump_get_line() starts with the oldest records. With the next call,
> the iterator retrieves one line after the other. Useful for cases like
> printing to a console or any other stream device.
> 
> kmsg_dump_get_buffer() fills a buffer with as many of the youngest
> records as fit into it. With the next call, the iterator retrieves the
> next block of older messages. Useful to dump the entire buffer with one
> shot, or chunk the data into blocks and store them, with the youngest
> messages being the most important, retrieved first.
> 
> Unlike the old logic, there are no stale pointers handed out to the
> dumper, if case things get overwritten while a dump is in progress,
> lines are not truncated or overwritten.

As no one seems to have responded, care to resend this with a
signed-off-by so I can queue it up for 3.6?  If people complain, it can
still go to 3.5, but given that no one is saying anything, I guess no
one cares...

thanks,

greg k-h
