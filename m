Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0EMRQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 13:16:48 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:45391 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0EMRQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 13:16:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QGsKh1+IbD7DshI3pOLgEYKyUJs2woZtVvYIke1Po9TZgazDmk8aDo4Jn7fz+2wmkn
         DZLrxLqRakDcv62sT+hM5G26rVTw9v6jHTThcmx8E1v6O1MQbCQC6dRK/Z42vUgng1zM
         ujXqqqKbK3Nn0BGmVMaqYlb882PCGb5WYyklI=
Date: Thu, 13 May 2010 10:16:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100513171639.GA23708@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <20100513160117.GB22238@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 09:54:00AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 13 May 2010, Dmitry Torokhov wrote:
> > 
> > Apple does proper thing in BIOS and omits keyboard and mouse PNP
> > devices, but because of other players we do not really trust PNP BIOS
> > and resort to banding on ports directly - there are cases when box has
> > mouse and/or keyboard but they are not present in BIOS. Damed if you do,
> > damned if you don't...
> 
> Umm. No.
> 
> PnP information _commonly_ doesn't inclure PS/2 ports, even when they 
> exist. Lack of PnP information about the keyboard port means absolutely 
> nothing, and anybody who tells you otherwise is totally and utterly wrong. 
>

I think on the newer hardware PNP (or rather ACPI mapped onto PNP) usually 
matches the reality.

> So don't confuse this with PnP issues. That's a total red herring, and 
> Apple is _not_at_all_ "doing the proper thing in the BIOS". 
> 
> Quite the reverse. Apple is very clearly doing something horribly _wrong_ 
> in their BIOS. Don't give them kudos for being incompetent morons.
> 
> Just google for
> 
> 	"Probing ports directly" "i8042 KBD port"
> 
> and you'll get a lot of hits. That's not because those machines have wrong 
> PnP tables - it's because fundamentally PNP is a joke, and on PC's what is 
> much more important is "standard IO ports". 
> 
> For example, in that thread, Bastien is quoted:
> 
> 	> In other words, on x86, if PNP and/or ACPI don't indicate any PS/2 
> 	> controller exists, we randomly bang on the ports in the expectation 
> 	> they'll be there anyway. This seems rather misguided.
> 
> and all that tells me is that Bastien doesn't know what he is doing. It is 
> _not_ "randomly bang" - it's called standard PC hardware.

Do Macs qualify to be called "standard PC hardware" though? Again, there
are BootCamp BIOSes that allow you booting XP on them, and most likely
newer models already have that ironed out, but we can't expect older
ones to survive port probing.

>  And it's not 
> "misguided" - it's very much correct and required, exactly because PnP 
> itself is the misguided aborted fetus of a braindamaged mind.
> 
> We do not trust BIOS tables, because BIOS writers are invariably totally 
> incompetent crack-addicted monkeys. If they weren't, they wouldn't be BIOS 
> writers. QED. And in fact the Apple problem is an _example_ of this BIOS 
> writer incompetence, not some shining example of them doing something 
> right.

Well, they got PNP tables right ;)

-- 
Dmitry
