Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab1EKXTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 19:19:44 -0400
Received: from kroah.org ([198.145.64.141]:41588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699Ab1EKXTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 19:19:33 -0400
Date: Wed, 11 May 2011 16:19:22 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 04/12] staging: usbip: replace usbip_u{dbg,err,info} and
 printk with pr_ equivalent
Message-ID: <20110511231922.GD7362@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
 <0c3a71ba4811a3ab470d307650067e9c2b52379b.1305103212.git.mfm@muteddisk.com>
 <20110511210639.GA4679@kroah.com>
 <BANLkTimBxkF4KbXfm7Ma8cmpDF9EPjfMWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimBxkF4KbXfm7Ma8cmpDF9EPjfMWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 03:51:58PM -0700, matt mooney wrote:
> On Wed, May 11, 2011 at 2:06 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, May 11, 2011 at 01:54:16AM -0700, matt mooney wrote:
> >> This switches all of the non dev_<level> print statements to use the
> >> pr_<level> macros. And a few debug statements are removed.
> >
> > Can't most of these be moved to use the dev_* calls instead?
> 
> I believe so and had planned to do this is in a second pass.

Ah, you didn't say that :)

> >> Signed-off-by: matt mooney <mfm@muteddisk.com>
> >> ---
> >>  drivers/staging/usbip/stub_dev.c     |   22 ++--
> >>  drivers/staging/usbip/stub_main.c    |   19 ++--
> >>  drivers/staging/usbip/stub_rx.c      |   24 ++--
> >>  drivers/staging/usbip/stub_tx.c      |   16 ++--
> >>  drivers/staging/usbip/usbip_common.c |  228 +++++++++++++++------------------
> >>  drivers/staging/usbip/usbip_common.h |   46 +------
> >>  drivers/staging/usbip/usbip_event.c  |    3 +-
> >>  drivers/staging/usbip/vhci_hcd.c     |   87 +++++--------
> >>  drivers/staging/usbip/vhci_rx.c      |   33 +++---
> >>  drivers/staging/usbip/vhci_sysfs.c   |   14 +-
> >>  drivers/staging/usbip/vhci_tx.c      |    8 +-
> >>  11 files changed, 209 insertions(+), 291 deletions(-)
> >>
> >> diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
> >> index c71d0a3..0c0d838 100644
> >> --- a/drivers/staging/usbip/stub_dev.c
> >> +++ b/drivers/staging/usbip/stub_dev.c
> >> @@ -196,7 +196,7 @@ static void stub_shutdown_connection(struct usbip_device *ud)
> >>        * step 1?
> >>        */
> >>       if (ud->tcp_socket) {
> >> -             usbip_udbg("shutdown tcp_socket %p\n", ud->tcp_socket);
> >> +             pr_debug("shutdown tcp_socket %p\n", ud->tcp_socket);
> >
> > Like here, we have a valid struct device pointer from what I can tell,
> > so we should use dev_dbg() instead of pr_debug().
> >
> > I think a lot of these conversions could use those calls here, right?
> >
> > So care to split this into 2 patches, one that converts to valid usages
> > of the dev_* calls, and the other a patch that converts the rest to pr_*
> > calls?
> 
> Do you mind just taking this as is for now? That way I can do the
> dev_dbg() conversion on a case by case basis as I become more familiar
> with the code, which was kind of my original plan. This patch still
> provides a fair amount of cleanup ;)

Yes it does, but I would prefer if you did it right the first time.
It's neater that way and makes more sense.

So, can you please redo this and resend it?

thanks,

greg k-h
