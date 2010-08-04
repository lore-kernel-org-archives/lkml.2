Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab0HDGUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:20:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57401 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab0HDGU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EY4oxVzyMxLwiLNSrNw+GcQTmQL/lckcTvyUMWMfmRl7kkGkHB0wGYrf+dmy2sVCiL
         /+LhWy3xJm5oxYPgboQsGATSzZjfV45E5c1FAAH2jcNnD9MGNbW00QkyyhT0iO33FJ7y
         V+btPdfTqfMXwmBEXsO+zbzgh3X6THGwQADKA=
Date: Tue, 3 Aug 2010 23:20:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Anisse Astier <anisse@astier.eu>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100804062021.GA25742@core.coreip.homeip.net>
References: <20100513075728.GF30110@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
 <20100514145539.GA5598@srcf.ucam.org>
 <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 08:16:34AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 14 May 2010, Matthew Garrett wrote:
> >
> > I've done some experimentation under qemu. On ACPI systems, Windows will 
> > *only* touch the keyboard controller if there's a device with an 
> > appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f. 
> > Otherwise it'll simply ignore the hardware entirely. By the looks of it 
> > their keyboard probing is also somewhat different to ours, but that's 
> > probably another story.
> 
> Well, I'd hate to lose the keyboard hotplug capability, but at the same 
> time, it _is_ 2010, and while I have personally used it historically, I 
> don't really foresee ever using it again.
> 
> So we _could_ decide to just try it, and see if anybody screams. If nobody 
> does, that would be a very simple solution to the problem.
> 

OK, time to ressurect the topic ;)

There is another report (from Anisse - CCed) - MSI AE2220 stops for 10
seconds when we try to see if "AUX DISABLE" command took effect (it
doesn't). While we should reduce the time we wait and retry to something
more reasonable it woudl not fix this issue completely.

The box does not have any PS/2 ports but in this case BIOS writers _did_
some crack and put PS/2 devices in DSDT. While the devices are most
likely not active and thus Matthew's patch would help Anisse I do hate
to loose the option of plugging PS/2 mouse/keyboard after boot and
having chance of them working. I would still like to add a few blacklist
entries instead.

Thanks.

-- 
Dmitry
