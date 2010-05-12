Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0ELTbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:31:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39550 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab0ELTa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:30:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xCKykjApqHXI+XnKD9b9TETTQO1aP0f9sDN4VRPAXO4dE5p9u8kUjZ5sC2Mr6EQKai
         MoIvMV8FiqYe2RWxOptlLZtfLE9RAujUfLrbcde+5hTNwyCeORtG5ksO408wY++tc+bF
         4PNK+mUMCAThE5Mx2AstPFcPlqWsMtLHBfu8A=
Date: Wed, 12 May 2010 23:30:50 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Introduce {sysfs,device}_create_file_mode
Message-ID: <20100512193050.GA14221@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <20100511174708.GA26777@oksana.dev.rtsoft.ru>
 <20100511175812.GH30801@buzzloop.caiaq.de>
 <20100511182347.GA31831@oksana.dev.rtsoft.ru>
 <20100511222825.GJ30801@buzzloop.caiaq.de>
 <20100512181546.GA4804@oksana.dev.rtsoft.ru>
 <20100512183806.GA28658@suse.de>
 <20100512190814.GA9674@oksana.dev.rtsoft.ru>
 <AANLkTimQq30DklQUDBokPXsLiXKsuiaCUFg_5ddkJbXa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimQq30DklQUDBokPXsLiXKsuiaCUFg_5ddkJbXa@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 09:12:46PM +0200, Kay Sievers wrote:
> On Wed, May 12, 2010 at 21:08, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > On Wed, May 12, 2010 at 11:38:06AM -0700, Greg KH wrote:
> >> On Wed, May 12, 2010 at 10:15:46PM +0400, Anton Vorontsov wrote:
> >> > We need to create attributes with different modes across devices.
> >> > We can do this by modifying attr.mode between device_create_file
> >> > invocations, but that is racy in case of globally defined attrs.
> >> >
> >> > Luckily, there's sysfs_add_file_mode() function that seems to do
> >> > exactly what we want, and if we use it, we don't need any locks
> >> > to avoid races. Though, it isn't exposed via device-drivers core
> >> > API.
> >>
> >> But you race the creation of the device notifying userspace, and then
> >> the file being created, right?
> >
> > Yep, you've raised that question once, like 3 years ago. :-)
> >
> > http://lkml.org/lkml/2007/4/11/452
> > http://lkml.org/lkml/2007/4/12/144
> >
> > In short: we can't use attr groups since the attributes creation
> > is conditional. And we especially don't want to use the attr groups
> > for attrs with different modes. But it's not a problem, because...
> 
> Groups have a filter callback for every member, to decide if the
> attribute should be created or not.

Thanks Kay. It seems the callback was added just a few months
after the discussion above. ;-)

And this commit looks especially cool:

commit 0f4238958d28044b335644b69df6071cdb04b5ce
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Thu Mar 20 20:47:52 2008 -0500

    [SCSI] sysfs: make group is_valid return a mode_t

Daniel, I think that today we can just use the attribute group
mechanism, it has all needed. Do you want me to prepare a patch
to convert existing attributes, or do you to try it yourself?

Just asking to not duplicate efforts.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
