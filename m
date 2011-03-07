Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1CGUjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:39:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48533 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1CGUjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:39:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=FC0lCHzmxNNHJlJ0QV0PTX+GpS9xfiBVTeaF49DrdfY87ZJ8YDmiB0b2BiEqY4L/YP
         8X1uniH/jFaRKuis9MzMV9Ujtesyd6YDEJtPI09RyMLyu7JYA4pIkukDSBHu4K5bC693
         uQLMm3MCCk2HvG0rviVnHSyWSW1ob5c0PRuBs=
Date: Mon, 7 Mar 2011 23:38:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/21] staging: ft1000: Fix coding style in
 ft1000_usb_transmit_complete function.
Message-ID: <20110307203858.GY3416@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Belisko Marek <marek.belisko@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
 <1299486086-7325-12-git-send-email-marek.belisko@open-nandra.com>
 <20110307155529.GV3416@bicker>
 <AANLkTiknavmcagz63oFmqhgF5nV6xEMmLwU=i129LcVB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTiknavmcagz63oFmqhgF5nV6xEMmLwU=i129LcVB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 08:25:07PM +0100, Belisko Marek wrote:
> On Mon, Mar 7, 2011 at 4:55 PM, Dan Carpenter <error27@gmail.com> wrote:
> > On Mon, Mar 07, 2011 at 09:21:16AM +0100, Marek Belisko wrote:
> >> -    if (urb->status)
> >> -        printk("%s: TX status %d\n", ft1000dev->net->name, urb->status);
> >> +     if (urb->status)
> >> +             DEBUG("%s: TX status %d\n", ft1000dev->net->name, urb->status);
> >>
> >
> > Why did you change the printk() to a DEBUG()?  That's a behavior change,
> > and it should have been mentioned in the commit message.
> Mea culpa. checkpatch.pl complain about no KERN_... prefix so just fix with
> replace to DEBUG. Will return back to printk.
> @Greg: should resend whole serie or just this patch?

pr_err() or pr_info() would probably be better.

Here is how the usb-skeleton driver handles this btw:  

        /* sync/async unlink faults aren't errors */
        if (urb->status) {
                if (!(urb->status == -ENOENT ||
                    urb->status == -ECONNRESET ||
                    urb->status == -ESHUTDOWN))
                        err("%s - nonzero write bulk status received: %d",
                            __func__, urb->status);

                dev->errors = urb->status;
        } else {
                dev->bulk_in_filled = urb->actual_length;
        }

That uses the old usb err() macro which I think is not recomended these
days.  Use pr_err() instead.

Do the other patches still apply if you resend just this patch?  Btw
git send-email has a --in-reply-to option so that the V2 is attached to
the same thread as the original patch.

regards,
dan carpenter

