Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2BBWEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:04:41 -0500
Received: from imr4.ericy.com ([198.24.6.9]:36750 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab2BBWEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:04:39 -0500
Message-ID: <1328220172.2261.162.camel@groeck-laptop>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Peter Tyser <ptyser@xes-inc.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 2 Feb 2012 14:02:52 -0800
In-Reply-To: <1328212615.12622.193.camel@petert>
References: <20110419145303.111aead7@endymion.delvare>
	 <20120202023129.GA19535@ericsson.com>
	 <20120202084909.2adf0f50@endymion.delvare>
	 <1328204105.2261.140.camel@groeck-laptop>
	 <1328212615.12622.193.camel@petert>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 14:56 -0500, Peter Tyser wrote:
> <snip>
> 
> > > > >  drivers/gpio/Kconfig     |    7
> > > > >  drivers/gpio/Makefile    |    1
> > > > >  drivers/gpio/i801_gpio.c |  432 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 440 insertions(+)
> > > >
> > > > Did this or an alternate patch for gpio support on the recent Intel ICHs go anywhere ?
> > > > 
> > > > I found another patch which is using a different approach, but I don't see anything
> > > > in the latest kernel.
> > > 
> > > I don't think any driver made it into the kernel, at least I can't find
> > > any in 3.3-rc2 nor linux-next. I'm not surprised, as neither driver was
> > > using the MFD framework while this would really be the right thing to
> > > do here. I never took the time to convert my driver to MFD and
> > > apparently Peter did not either. This is still on my to-do list but you
> > > know how long it is. If anyone is faster than me at getting the code is
> > > a shape suitable for upstream, I'll be happy to help with review and
> > > testing.
> > > 
> > I'd love to take this on, but unfortunately my task list isn't getting
> > shorter either. Just bad that this doesn't seem to make it in.
> > 
> > One reason of course may be that at least Peter's version tried to
> > accomplish too much. Looking through the comments, seems there was a
> > disagreement on unrelated issues such as if there should be a new
> > "unknown" gpio direction or not. Maybe it would make more sense to
> > separate the core patch to add ICH gpio support from the rest of Peter's
> > proposed changes.
> 
> I agree with Jean, I believe the main issue it wasn't accepted was the
> fact that it didn't use the MFD framework.  The driver I submitted
> follows the model of other drivers that share the same PCI device (iTCO,
> esb2rom, etc), so is functionally OK to use as is, it just doesn't use
> the recommend MFD framework, which was gating its acceptance.
> 
> > Peter, do you have any plans to work on this in the near future ?
> 
> I too have been caught up in other tasks.  A co-worker recently created
> a patch to transition the ICHx gpio driver I wrote and other related
> drivers (esb2rom, iTCO, etc) to the MFD structure with the intention
> that it would eventually be merged upstream.  The patch is still under
> review internally, but I'll talk to him about submitting it upstream.

Would you be willing to share your current code ? Even if it is too
early for upstream submission, you might get some testing and review
feedback.

Thanks,
Guenter


