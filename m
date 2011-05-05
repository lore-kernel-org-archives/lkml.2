Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1EEOa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:30:57 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:36042 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1EEOaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=rnWf8GM3AATl8dCuKkUtHN6kPzhJQJIGZX6t00N0p7AHmxrlcGqlF1P3eYz0zh0IPX
         u+G4jxfxWkE9pGsTY473dXq4PVQN//+06kAy5F1voXRj1KSAyf6moaILk5i4U77RIKVZ
         kJhCeIcwgWNsVLYZh3yz6KvO1BV1CQ2MGuh9s=
Subject: Re: [PATCH] C2port:Fix deprecated exported interfaces c2port.h
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110505141024.GA6461@suse.de>
References: <1304598549-3561-1-git-send-email-wanlong.gao@gmail.com>
	 <20110505141024.GA6461@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Linux kernel
Date: Thu, 05 May 2011 22:30:40 +0800
Message-ID: <1304605840.1903.7.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2011-05-05 07:10 -0700，Greg KH wroted：
> On Thu, May 05, 2011 at 08:29:09PM +0800, Wanlong Gao wrote:
> > From: Wanlong Gao <wanlong.gao@gmail.com>
> > 
> > Change to_class_dev to to_device since the struct class_device had
> > merged to struct device.
> > Fix the to_c2port_device interface since the struct c2port_device
> > has no member named class.
> > 
> > Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> > ---
> >  include/linux/c2port.h |    4 ++--
> 
> I don't know why you sent this to me, have you looked at the
> scripts/get_maintainer.pl tool?
Yes, I have, but I just get the linux-kernel open list, so I have
no idea but send it to you.
> 
> 
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/c2port.h b/include/linux/c2port.h
> > index 2a5cd86..7e6bd33 100644
> > --- a/include/linux/c2port.h
> > +++ b/include/linux/c2port.h
> > @@ -60,8 +60,8 @@ struct c2port_ops {
> >   * Exported functions
> >   */
> >  
> > -#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
> > -#define to_c2port_device(obj) container_of((obj), struct c2port_device, class)
> > +#define to_device(obj) container_of(obj, struct device, kobj)
> > +#define to_c2port_device(obj) container_of(obj, struct c2port_device, dev.kobj)
> 
> Doesn't this break the build?  If not, something is really wrong here.
The interface just exported but not used in the kernel code, so it will
not break the build. The class_device structure is deprecated in your
driver-core, so it really has something wrong here.
> 
> confused,
Me too, I checked the log and see that the to_c2port_device had
something wrong in this file's initial version.
> 
> greg k-h

Thanks
Best regards

Wanlong Gao

