Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1AZTdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:33:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64499 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1AZTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:33:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C8K2SE0Oc7xZS9R8j6smbv2O63+C7ATnjJtXYz4pVUl1xAvv2aGwN4n9XLG4JXxzaH
         flwB61Einh70LvflKZN9fo2BYbV+fx6AU14WS7AHeZsEx1+U4bgOirJP9PWoiGeh1+Os
         71e/MDpMm1LPpMnoqthSR4c54eQhv49qOGE3g=
Date: Wed, 26 Jan 2011 11:32:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126193259.GC29268@core.coreip.homeip.net>
References: <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D4004F9.6090200@redhat.com>
 <4D401CC5.4020000@redhat.com>
 <4D402D35.4090206@redhat.com>
 <20110126165132.GC29163@core.coreip.homeip.net>
 <4D4059E5.7050300@redhat.com>
 <20110126182415.GB29268@core.coreip.homeip.net>
 <4D4072F9.5060206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4072F9.5060206@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:16:09PM +0100, Gerd Hoffmann wrote: >   Hi,
> 
> >>>The check should be against concrete version (0x10000 in this case).
> 
> Stepping back: what does the version mean?
>

Nothing, it is just a number.
 
> 0x10000 == 1.0 ?
> 0x10001 == 1.1 ?

No, not really.

> 
> Can I expect the interface stay backward compatible if only the
> minor revision changes, i.e. makes it sense to accept 1.x?

I am not planning on breaking backward compatibility.

> 
> Will the major revision ever change?  Does it make sense to check
> the version at all?

It depends. We do not have a clear way to see if new ioctls are
supported (and I do not consider "try new ioctl and see if data sticks"
being a good way) so that facilitated protocol version rev-up. So keymap
manipulating tools might be forced to check protocol version. For the
rest I think doing EVIOCGVERSION just to check that ioctl is supported
is an OK way to validate that we are dealing with an event device, but
that's it.

BTW, maybe we should move lsinput and input-kbd into linuxconsole
package, together with evtest, fftest, etc?

-- 
Dmitry
