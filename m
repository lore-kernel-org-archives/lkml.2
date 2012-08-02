Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2HBVea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:34:30 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:40088 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab2HBVe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:34:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
Date: Thu, 2 Aug 2012 23:40:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>, bhelgaas@google.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <50158321.4030007@gmx.net> <201208022209.16015.rjw@sisk.pl> <501AE10E.6080606@gmx.net>
In-Reply-To: <501AE10E.6080606@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208022340.16948.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 02, 2012, Witold Szczeponik wrote:
> On 02/08/12 22:09, Rafael J. Wysocki wrote:
> > On Monday, July 30, 2012, Borislav Petkov wrote:
> >> On Sun, Jul 29, 2012 at 09:31:53PM +0200, Witold Szczeponik wrote:
> >>> the aim is to select a PNP ACPI option where resources can be disabled
> >>> (or are not needed).  E.g., the parallel port of the 600E can be used
> >>> with and without IRQ lines.  The means to allow for this is to use the
> >>> sysfs interface to select disabled resources (just like any other 
> >>> resource value).  In https://lkml.org/lkml/2011/7/3/41, I used the 
> >>> following example:
> >>>
> >>>   echo disable > /sys/bus/pnp/devices/$device/resources
> >>>   echo clear > /sys/bus/pnp/devices/$device/resources
> >>>   echo set irq disabled > /sys/bus/pnp/devices/$device/resources
> >>>   echo fill > /sys/bus/pnp/devices/$device/resources
> >>>   echo activate > /sys/bus/pnp/devices/$device/resources
> >>>
> >>> The third line is made possible by the patch series.  All other
> >>> lines are already implemented.
> >>
> >> Shouldn't this be rather "disable_irq" or something which is a single
> >> word and thus would simplify parsing a lot?
> > 
> > Or just "irq", which isn't going to be confused with anything else it seems.
> > 
> > Thanks,
> > Rafael
> > 
> 
> Hi Rafael, 
> 
> the code in "drivers/pnp/interface.c" implements a (non-trivial) interface
> which accepts the keywords "disable", "activate", "fill", "auto", "clear",
> and "get" as simple, one word commands.  The remaining "set" command is
> more complex, for it determines which resource is to be set ("io", "mem",
> "irq", "dma", and "bus"), followed by the actual value(s) of this resource
> (e.g., "0x0200-0x021f", or "7"). 
> 
> The patch series allows to use the term "disabled" or "<none>" as a 
> resource value (c.f. my example above) when needed (c.f. my motivation for
> the patch series). 
> 
> We could, of course, change the parser in "interface.c", but this would 
> change the ABI, I am afraid.  Something that I'd rather not do... 

Still, you _are_ doing that by extending the ABI, aren't you?

> I hope, this makes the scope of the patch series clear(er).

Yes, it does, thanks.

My opinion is that the whole interface is wrong and should be changed.  How to
do that is a different matter that would require some consideration.  Perhaps
the least painful way would be to add a new, hopefully better, interface along
with the old one and then deprecate the latter at one point.

Now, since I don't like the existing interface, I'd prefer it not to be
extended.

Thanks,
Rafael
