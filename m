Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab0FBKHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:07:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab0FBKHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V03JO8yKRgMgVuJZ005kHyAHaDK04haukJNmndqpBfeOtDXULzv/+mDqFJMf99Ayq3
         26NRNO/8Rm7d8Lmde/4uYgqeC5K39Lh0JMxNVH+iR1goB5/5/ihbu4iM/rx6c2pnrfw9
         f9iT8wzusROT/ByIJyjTCO+btMQdNm/ig2wjA=
Subject: Re: RAMOOPS: few questions
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C0622BF.8070602@gmail.com>
References: <1275420747.2574.8.camel@maxim-laptop>
	 <4C0622BF.8070602@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 13:07:32 +0300
Message-ID: <1275473252.11579.17.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 11:22 +0200, Marco Stornelli wrote: 
> Il 01/06/2010 21:32, Maxim Levitsky ha scritto:
> > Hi,
> > 
> > I want to switch over my own patch that does more or less the same that
> > this driver.
> > 
> > As I see this driver uses ioremap to reserve the memory.
> > However, I have a question about how to tell kernel that specific memory
> > region is reserved.
> > 
> > Well, I use now mem=... to do so, but this wastes space, because the
> > region I need can't be near end of the RAM.
> > 
> 
> Have you got any particular constraints?
The trick I use, and works on most systems is that bios doesn't bother
to clear RAM on reboot. It still uses it for its own purposes.


> 
> > I tried to use 'memmap=20M$0x70000000' on kernel command line, but that
> > just makes kernel reboot.
> > I think its a bug though.
> > 
> > Also, does this driver dupms all kernel log or only panic/oops message?
> 
> It dumps all, but there's a fixed size for each dump, so you can see the
> panic/oops information and the latest prints of the kernel before
> panic/oops.
Thats fine.

> 
> > My patch actually makes kernel store actual printk buffer in fixed
> > location, thus it is very robust. It was rejected though in favour of
> > solution you eventually implemented.
> > 
> > Also I would like to extend your driver to dump old contents of the ram
> > buffer to kernel log, so one wouldn't worry about erasing in on next
> > boot after crash.
> > Don't know when I do that though.
> > 
> 
> ramoops uses a circular buffer of fixed size to store more information.
> The number of "dumps" depends on the region size of memory you use.

You mean it is smart enough not to overwrite the reserved region on next
boot after the crash provided that I managed to tell kernel not to use
it?

This definitely looks promising. I was thinking do to the same thing
when I get free time.

There are still issues though comparing to mine implementation.

Namely, my approach allows to look at kernel log of last kernel even if
there was no panic/oops, and this comes handy when system has reset
button, and your graphical card decides to hang....
However the dump mechanism isn't suitable for that task, but rather a
console.

And second problem is that your driver kicks in quite late stage, while
I managed to start the logging quite early.
Maybe its possible to switch from module_init to some early initcall.
Note that then I had to use ioremap_early.

And last thing that that I suffer from too, is inability to reserve a
region from kernel command line.

memmap=20M$0x70000000 doesn't work.


Thanks for your driver.


Best regards,
Maxim Levitsky

