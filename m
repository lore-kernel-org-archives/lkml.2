Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0FEAp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:45:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53020 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab0FEAp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:45:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XN2iCky8IL42kCL0PIR7i+DNmA1gc4muaUqx0X/TO02pdqP0VjNrNvXrELOfXEF7pr
         5pAK3sCurgNjRuPj3ssIbfBu/L0G32QG6ZvJO3gnlUClu9KC6Xqwuh7UAZrbZeAGO95l
         KZ/k+vf/vOkvUxfH9IML6sa02r0XPxeWz3fQA=
Subject: Re: [SUSPECTED SPAM] Re: [linux-pm] Proposal for a new algorithm
 for reading & writing a hibernation image.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
In-Reply-To: <1275698169.10045.8.camel@maxim-laptop>
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
	 <1275694775.3853.29.camel@maxim-laptop>  <4C09930E.20306@crca.org.au>
	 <1275698169.10045.8.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 03:45:20 +0300
Message-ID: <1275698720.10045.15.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-05 at 03:36 +0300, Maxim Levitsky wrote: 
> On Sat, 2010-06-05 at 09:58 +1000, Nigel Cunningham wrote: 
> > Hi Maxim.
> > 
> > On 05/06/10 09:39, Maxim Levitsky wrote:
> > > On Thu, 2010-06-03 at 16:50 +0200, Pavel Machek wrote:
> > >>
> > >> "Nigel Cunningham"<ncunningham@crca.org.au>  wrote:
> > >>
> > >>> Hi.
> > >>>
> > >>> On 30/05/10 15:25, Pavel Machek wrote:
> > >>>> Hi!
> > >>>>
> > >>>>> 2. Prior to writing any of the image, also set up new 4k page tables
> > >>>>> such that an attempt to make a change to any of the pages we're about to
> > >>>>> write to disk will result in a page fault, giving us an opportunity to
> > >>>>> flag the page as needing an atomic copy later. Once this is done, write
> > >>>>> protection for the page can be disabled and the write that caused the
> > >>>>> fault allowed to proceed.
> > >>>>
> > >>>> Tricky.
> > >>>>
> > >>>> page faulting code touches memory, too...
> > >>>
> > >>> Yeah. I realise we'd need to make the pages that are used to record the
> > >>> faults be unprotected themselves. I'm imagining a bitmap for that.
> > >>>
> > >>> Do you see any reason that it could be inherently impossible? That's
> > >>> what I really want to know before (potentially) wasting time trying it.
> > >>
> > >> I'm not sure it is impossible, but it certainly seems way too complex to be
> > >> practical.
> > >>
> > >> 2mb pages will probably present a problem, as will bat mappings on powerpc.
> > >
> > >
> > > Some time ago, after tuxonce caused medium fs corruption twice on my
> > > root filesystem (superblock gone for example), I was thinking too about
> > > how to make it safe to save whole memory.
> > 
> > I'd be asking why you got the corruption. On the odd occasion where it 
> > has been reported, it's usually been because the person didn't set up 
> > their initramfs correctly (resumed after mounting filesystems). Is there 
> > any chance that you did that?
I didn't use any initramfs.
I did use kernel modesetting and nouveau.
I used ext4.
The corruption happened after normal suspend.
I replaces swsusp with tuxonice.

Anyway, some more or less verified method must be used to save memory
because fs corruption is too scary thing to have.

I can't say it scared me that much 'cause I had dealt with worse
corruptions before, but being thrown to  "grub rescue>" on boot is not
pleasant thing to see.

Best regards,
Maxim Levitsky


