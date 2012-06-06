Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab2FFGdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:33:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48652 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439Ab2FFGdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:33:23 -0400
X-Sasl-enc: KjEJODqAM6v0+OZthhpBk2bm1S68fICALPouyUF2pYOX 1338964402
Date: Wed, 6 Jun 2012 15:33:19 +0900
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120606063319.GA1807@kroah.com>
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

Any comments on this patch?  Did anyone try it out?  I want to merge it
now, so unless someone objects, will do so soon.

thanks,

greg k-h
