Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1EEOy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:54:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59562 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1EEOy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=JmztG9W7ahLAfKR/+Bmaxh/8u4c/bkHsOzigUyZNZ6pdetf1GxpbueGKCO84hte+bj
         iq4yfN69vr1otuG2HQ0CojAITSVsJaV9eJCityDwn29kZcjU7uFjhUNrxddkJU6d1744
         DarQfdD3oz8c7w9INlOCsi++pJTcF3Y0rlKZE=
Subject: Re: [PATCH] C2port:Fix deprecated exported interfaces c2port.h
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, giometti@linux.it
In-Reply-To: <20110505143901.GA12487@suse.de>
References: <1304598549-3561-1-git-send-email-wanlong.gao@gmail.com>
	 <20110505141024.GA6461@suse.de> <1304605840.1903.7.camel@Tux>
	 <20110505143901.GA12487@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Linux kernel
Date: Thu, 05 May 2011 22:54:16 +0800
Message-ID: <1304607256.1903.12.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2011-05-05四的 07:39 -0700，Greg KH wroted ：
> On Thu, May 05, 2011 at 10:30:40PM +0800, Wanlong Gao wrote:
> > on 2011-05-05 07:10 -0700，Greg KH wroted：
> > > On Thu, May 05, 2011 at 08:29:09PM +0800, Wanlong Gao wrote:
> > > > From: Wanlong Gao <wanlong.gao@gmail.com>
> > > > 
> > > > Change to_class_dev to to_device since the struct class_device had
> > > > merged to struct device.
> > > > Fix the to_c2port_device interface since the struct c2port_device
> > > > has no member named class.
> > > > 
> > > > Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> > > > ---
> > > >  include/linux/c2port.h |    4 ++--
> > > 
> > > I don't know why you sent this to me, have you looked at the
> > > scripts/get_maintainer.pl tool?
> > Yes, I have, but I just get the linux-kernel open list, so I have
> > no idea but send it to you.
> 
> Ok, you are right that get_maintainers.pl doesn't show anything, but
> look at the git history, you will see that Rodolfo Giometti
> <giometti@linux.it> originally added this code, so that is who you need
> to copy on any patch.
I see, I see, thank you very much.
> 
> > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/include/linux/c2port.h b/include/linux/c2port.h
> > > > index 2a5cd86..7e6bd33 100644
> > > > --- a/include/linux/c2port.h
> > > > +++ b/include/linux/c2port.h
> > > > @@ -60,8 +60,8 @@ struct c2port_ops {
> > > >   * Exported functions
> > > >   */
> > > >  
> > > > -#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
> > > > -#define to_c2port_device(obj) container_of((obj), struct c2port_device, class)
> > > > +#define to_device(obj) container_of(obj, struct device, kobj)
> > > > +#define to_c2port_device(obj) container_of(obj, struct c2port_device, dev.kobj)
> > > 
> > > Doesn't this break the build?  If not, something is really wrong here.
> > The interface just exported but not used in the kernel code, so it will
> > not break the build. The class_device structure is deprecated in your
> > driver-core, so it really has something wrong here.
> 
> What is wrong is that these macros are never used, otherwise they would
> break the build.  So I'm pretty sure you can just remove them safely,
> but run it by Rodolfo first please.
Thanks a lot for your tips, I'll just remove it.
> 
> thanks,
> 
> greg k-h

Best regards
Wanlong Gao

