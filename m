Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619Ab0GHSnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:43:00 -0400
Received: from kroah.org ([198.145.64.141]:54305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0GHSmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:42:55 -0400
Date: Thu, 8 Jul 2010 11:39:03 -0700
From: Greg KH <greg@kroah.com>
To: Joey Lee <jlee@novell.com>
Cc: axel.lin@gmail.com, mzxreary@0pointer.de, rpurdie@linux.intel.com,
       mjg@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] msi-laptop: make struct rfkill_ops const
Message-ID: <20100708183903.GD31823@kroah.com>
References: <4C369D2B020000230001CA27@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C369D2B020000230001CA27@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 11:53:15AM -0600, Joey Lee wrote:
> Hi Axel, 
> 
> 於 四，2010-07-08 於 10:08 +0800，Axel Lin 提到：
> > rfkill uses a const struct rfkill_ops pointer.
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/platform/x86/msi-laptop.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
> > index afd762b..05634f8 100644
> > --- a/drivers/platform/x86/msi-laptop.c
> > +++ b/drivers/platform/x86/msi-laptop.c
> > @@ -562,15 +562,15 @@ static int rfkill_threeg_set(void *data, bool blocked)
> >  	return 0;
> >  }
> >  
> > -static struct rfkill_ops rfkill_bluetooth_ops = {
> > +static const struct rfkill_ops rfkill_bluetooth_ops = {
> >  	.set_block = rfkill_bluetooth_set
> >  };
> >  
> > -static struct rfkill_ops rfkill_wlan_ops = {
> > +static const struct rfkill_ops rfkill_wlan_ops = {
> >  	.set_block = rfkill_wlan_set
> >  };
> >  
> > -static struct rfkill_ops rfkill_threeg_ops = {
> > +static const struct rfkill_ops rfkill_threeg_ops = {
> >  	.set_block = rfkill_threeg_set
> >  };
> >  
> 
> The patch good to me, do I need Signed-off it?
> How can I signed off a patch?

You can say:
	Signed-off-by: your name <your_email>

and then Matthew will add it.

Or you can take the original patch, add your signed-off-by, and resend
it to Matthew keeping the correct authorship information there by making
sure the first line in the body of the email has:
	From: Original author <email>

so git will get it right.

hope this helps,

greg k-h
