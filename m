Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab0EMPul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:50:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44374 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0EMPuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:50:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sm8ff8CRV9gI7hG4FGwPNSJtQOj36kMPekWU6to8eYq2iAvmxff0iR1aaZOjdUGoVf
         IurDhqK6l9n20/YPsnWn1P2f7iTAOtfqPxg35/lJ5GkaOI2+0HjhG8UXr0/jXsJj4MVL
         rW8JaywJmYJYO/xyx4km632aoWI5KwE9FGhSQ=
Date: Thu, 13 May 2010 08:50:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bastien Nocera <hadess@hadess.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100513155031.GA22238@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <1273762051.2308.4671.camel@localhost.localdomain>
 <alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:04:15AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 13 May 2010, Bastien Nocera wrote:
> > 
> > Maybe you didn't update to the latest firmwares on you Mac Mini, and
> > didn't see the problem with the updated BIOSes, I don't know.
> 
> I can't update the firmware, since it's some random OS X program that does 
> it (and I don't have OS X on the machine).
> 
> But where does it lock up? During the boot probing? Or does it probe as 
> having a keyboard because Apple added some crazy SMM code to try to 
> emulate one with USB? 
> 
> Afaik, the Apple hardware actually does _physically_ have a keyboard 
> controller (it's on the regular intel southbridge silicon, afaik), it just 
> isn't connected to anything. And I think it is turned off in some of the 
> southbridge control registers. The control registers also allow trapping 
> into SMI when accessing the keyboard control registers, and maybe Apple 
> screwed up there somewhere.
> 
> On one of my Mac Mini's (didn't check the other), I get this:
> 
> 	[    2.955087] PNP: No PS/2 controller found. Probing ports directly.
> 	[    2.958475] i8042.c: No controller found.
> 	[    2.960998] mice: PS/2 mouse device common for all mice
> 
> what do you get?
> 
> The thing is, there's a _lot_ of machines out there with no legacy 
> keyboard support. They tend to work.

Indeed most of them do just work. My Dell T110 for example boots just
fine and it only has USB, no PS/2 ports. However there is a rather
important difference I think - these other boxes are supposed to work
with multiple versions of Windows which, as far as I know, do probe for
the i8042. Apple only supports bootcamp on certain BIOSes and does not
really expect anything to touch these ports.

> We have timeouts for the i8042 
> commands we do during init, but maybe we missed some case. And maybe we 
> could easily add some extra tests too.
> 
> A few printk's in the i8042 init routines to show where it locks up would 
> be good.. I assume you did that already if you and Dmitry already tried to 
> debug this. Where's the original thread?
> 

>From what I remember (it was a few weeks old thread) we were hanging
when trying to read from the controller in i8042_flush(). Normally, if
controller isn't there we'd get a stream of 0xff which will never
"clear" and so after 32 reads we give up and abort controller
initialization. But on Bastien's box it just sits there.

-- 
Dmitry
