Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab0ELTjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:39:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42277 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab0ELTjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DzkhLh+5HXwzM22Ak8Gzz9FbZ+l+o9RAP1+NQ+Sz3dN9j4tyB+5FBVhkxRJoQD5byp
         TfIw5WD+HMNdyjAmWL8CAsZ13dOgpQvR0Um0AdxLSJ30Ds06Z39QHHERg3wnKxfMtZ1C
         lnFIk1USt79MvhdJPQQZglRLirdLs02XB40GU=
Date: Wed, 12 May 2010 23:39:12 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Daniel Mack <daniel@caiaq.de>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Introduce {sysfs,device}_create_file_mode
Message-ID: <20100512193912.GA17500@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <20100511174708.GA26777@oksana.dev.rtsoft.ru>
 <20100511175812.GH30801@buzzloop.caiaq.de>
 <20100511182347.GA31831@oksana.dev.rtsoft.ru>
 <20100511222825.GJ30801@buzzloop.caiaq.de>
 <20100512181546.GA4804@oksana.dev.rtsoft.ru>
 <20100512183806.GA28658@suse.de>
 <20100512190814.GA9674@oksana.dev.rtsoft.ru>
 <AANLkTimQq30DklQUDBokPXsLiXKsuiaCUFg_5ddkJbXa@mail.gmail.com>
 <20100512191955.GA30861@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100512191955.GA30861@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 12:19:55PM -0700, Greg KH wrote:
> On Wed, May 12, 2010 at 09:12:46PM +0200, Kay Sievers wrote:
> > On Wed, May 12, 2010 at 21:08, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > > On Wed, May 12, 2010 at 11:38:06AM -0700, Greg KH wrote:
> > >> On Wed, May 12, 2010 at 10:15:46PM +0400, Anton Vorontsov wrote:
> > >> > We need to create attributes with different modes across devices.
> > >> > We can do this by modifying attr.mode between device_create_file
> > >> > invocations, but that is racy in case of globally defined attrs.
> > >> >
> > >> > Luckily, there's sysfs_add_file_mode() function that seems to do
> > >> > exactly what we want, and if we use it, we don't need any locks
> > >> > to avoid races. Though, it isn't exposed via device-drivers core
> > >> > API.
> > >>
> > >> But you race the creation of the device notifying userspace, and then
> > >> the file being created, right?
> > >
> > > Yep, you've raised that question once, like 3 years ago. :-)
> > >
> > > http://lkml.org/lkml/2007/4/11/452
> > > http://lkml.org/lkml/2007/4/12/144
> > >
> > > In short: we can't use attr groups since the attributes creation
> > > is conditional. And we especially don't want to use the attr groups
> > > for attrs with different modes. But it's not a problem, because...
> > 
> > Groups have a filter callback for every member, to decide if the
> > attribute should be created or not.
> 
> Yeah, that's how we solved that issue a long time ago :)

But not loud enough for us to notice. ;-)

> Can you please switch to using attribute groups now, so that userspace
> doesn't have to handle 'change' events?

Yep.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
