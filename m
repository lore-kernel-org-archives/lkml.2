Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab0EMSKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:10:15 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:50597 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0EMSKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cJvl9YjPCAnPj2YgCZS7tq8o7u4gts3PK9YJGg2PXAv1hUg+UGo2cfVXZFK7XZibgA
         IOEkzf5gpswffzvqliS8g9J3Ca+dwaZaTOdI8NhVSWNTv/z//NwsFS/Rbg1rpVepiV+b
         4hG1VtgUa2rV88ZkFD7PsRpJkvmF9HbHHx6RI=
Date: Thu, 13 May 2010 11:10:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100513181002.GB23708@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <20100513160117.GB22238@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
 <20100513171639.GA23708@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005131017070.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005131017070.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 10:30:23AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 13 May 2010, Dmitry Torokhov wrote:
> > 
> > I think on the newer hardware PNP (or rather ACPI mapped onto PNP) usually 
> > matches the reality.
> 
> Dmitry, you're just making things up.
> 
> I have in front of me a Core i5-670. You can't get much newer than that. 
> And yes, it has a PS/2 connector at the back. And lookie here:
> 
> 	[    1.756777] PNP: No PS/2 controller found. Probing ports directly.
> 	[    1.760645] serio: i8042 KBD port at 0x60,0x64 irq 1
> 	[    1.762087] serio: i8042 AUX port at 0x60,0x64 irq 12
> 	[    1.763591] mice: PS/2 mouse device common for all mice
>

You don't have anything plugged into the ports though, do you? I wonder
what your DSDT looks like.
 
> so let it go. You're wrong. PS/2 is a legacy device, and exactly like the 
> legacy IO memory region in 0xa000-0xffff (or the motherboard IO port 
> region 0x00-0xff) it may not be mentioned by the BIOS tables. But it's 
> still there.
> 
> This is also why I think it _would_ be acceptable to say that if you boot 
> from EFI, you have to find the PnP devices. The whole (and only, as far as 
> I know) point of EFI was that "legacy-free" thing.

Is there an interface a driver can use to query the style of boot used?

-- 
Dmitry
