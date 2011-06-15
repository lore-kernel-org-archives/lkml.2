Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1FOGXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 02:23:05 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44515 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1FOGXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 02:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=LV71Kx5OnD3QyJsGlcOWjqDqkrqIj6IeMfJCFCAYKxtt2Y79AjCecszeERPXEK6vrk
         iBQgMI/9yoHz5nAAS99jt5uWAFkVMjFekuKQZXPkNzk36Pf/0yh9dboCRPyEggJz10IT
         omuWhpjiJO+VMuYsq4hwuXObIlzr4n5ujujaM=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <20110615075803.3348b4ec@pluto.restena.lu>
References: <1308100165.2113.4.camel@Tux>
	<20110615075803.3348b4ec@pluto.restena.lu>
Date: Wed, 15 Jun 2011 14:22:59 +0800
Message-ID: <BANLkTimiv5T6cgRjkDfPwjh-c5AivYzhmA@mail.gmail.com>
Subject: Re: Possible deadlock when suspending framebuffer
From: Wanlong Gao <wanlong.gao@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Francis Moreau <francis.moro@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 1:58 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> Hi,
>
> On Wed, 15 Jun 2011 09:09:24 Wanlong Gao <wanlong.gao@gmail.com> wrote:
> > <snip>
> > Hi Francis:
> > can you test this patch?
>
> Do you have a deadlock trace which you are trying to fix?
No, I just look at the code and try to fix this but I'm not sure.
Can you teach me how to have a deadlock trace here?
Thanks
>
> It's either the caller of unregister_framebuffer() which must be
> changed to not call unregister_framebuffer with info's lock held or
> the code reacting on the notification that must not try to acquire the
> lock again.
>
> The interesting par is if console semaphore has some relation to this
> deadlock as the order for taking both varies... It could be
> lock_fb_info(); console_lock()  versus console_lock(); lock_fb_info()
>
I see, thanks
> Bruno
>
>
> > Thanks
> >
><snip>
>
> Not a good idea to stop taking fb_lock here.
> Pretty all calls of fb_notifier_call_chain are protected by info's
> lock, except the one for FB_EVENT_FB_UNREGISTERED a few lines further.
Yup, thanks
>
> IMHO it wou make sense to add the lock around that last one so all
> notifier chain calls are handled the same.
>
> <snip>
>



--
Best regards
Wanlong Gao
