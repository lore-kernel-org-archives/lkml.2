Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab0ETHPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:15:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50528 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab0ETHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aJKmo/HzQJhFgidGlcQ1qX5P+JUyWXXsi2nyt5jLEY3eFa8CNPufA145+MMAZLrMai
         6GNWB+OWlVfo3qTmFA43VZIsZO+40umdpUahfec8LUI40eFu6MFNQF5ZYDcwXrd0rLJn
         pzq459Bje5NqMithJS7J69tAkHGnkjKpMbAtc=
Date: Thu, 20 May 2010 00:08:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100520070855.GB8080@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <20100513181002.GB23708@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005131232350.3711@i5.linux-foundation.org>
 <201005131405.45732.dmitry.torokhov@gmail.com>
 <alpine.LFD.2.00.1005200054090.2921@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005200054090.2921@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:56:18AM -0400, Len Brown wrote:
> On Thu, 13 May 2010, Dmitry Torokhov wrote:
> 
> > On Thursday 13 May 2010 12:40:43 pm Linus Torvalds wrote:
> > > On Thu, 13 May 2010, Dmitry Torokhov wrote:
> > > > You don't have anything plugged into the ports though, do you?
> > > 
> > > No. It's a modern machine. But the port is there, and we've been very good
> > > at booting up and finding keyboards later (I've done it myself - headless
> > > machines that you hotplug a PS/2 keyboard into: it's not necessarily
> > > technically something you're supposed to do, but it has worked fine for
> > > me).
> > > 
> > > > I wonder what your DSDT looks like.
> > 
> > [... pulling LKML back in...]
> > 
> > Lookie, lookie:
> > 
> >                 Device (PS2K)
> >                 {
> >                     Name (_HID, EisaId ("PNP0303"))
> >                     Name (_CID, EisaId ("PNP030B"))
> >                     Method (_STA, 0, NotSerialized)
> >                     {
> >                         ShiftLeft (One, 0x0A, Local0)
> >                         If (And (IOST, Local0))
> >                         {
> >                             Return (0x0F)
> >                         }
> > 
> >                         Return (Zero)
> >                     }
> > ...
> > 
> >                 Device (PS2M)
> >                 {
> >                     Name (_HID, EisaId ("PNP0F03"))
> >                     Name (_CID, EisaId ("PNP0F13"))
> >                     Method (_STA, 0, NotSerialized)
> >                     {
> > 
> > But I guess because there are no devices plugged in ACPI they are "inactive" 
> > and thus ACPI drop them. I was always wondered by ACPI did that. Len?
> 
> I guess only a Windows person could answer this --
> since it is really a Windows-ism, rather than something that
> makes any sense based on what is in the ACPI spec itself.
> 

Then we should probably revisit this? I am not saying that we need to
try evaluating more than Windows does but we still should add the
devices into the tree so their presence can be detected.

-- 
Dmitry
