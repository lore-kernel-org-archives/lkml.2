Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab0DATFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:05:34 -0400
Received: from legolas.restena.lu ([158.64.1.34]:59848 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758683Ab0DATF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:05:29 -0400
Date: Thu, 1 Apr 2010 21:05:19 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (hid
 tree related)
Message-ID: <20100401210519.2ac3f3a5@neptune.home>
In-Reply-To: <20100401095304.487fffb4@pluto.restena.lu>
References: <20100401170639.9f2fe605.sfr@canb.auug.org.au>
	<alpine.LNX.2.00.1004010817420.8345@pobox.suse.cz>
	<20100401183530.516bbca6.sfr@canb.auug.org.au>
	<20100401095304.487fffb4@pluto.restena.lu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 April 2010 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> Hi Jiri, Stephen,
> 
> Wondering why x86 (32bit and 64bit) does not need to include the
> header but other arches (at least powerpc) need it.
> 
> Any idea via which header linux/uaccess.h gets included on x86?
> If nobody has checked by the time I get home I will determine that.

Here is the include path for x86:
included arch/x86/include/asm/uaccess.h
    from arch/x86/include/asm/sections.h:5,
    from arch/x86/include/asm/hw_irq.h:26,
    from include/linux/irq.h:233,
    from arch/x86/include/asm/hardirq.h:5,
    from include/linux/hardirq.h:10,
    from include/linux/interrupt.h:12,
    from include/linux/usb.h:15,
    from drivers/hid/hid-picolcd.c:26:

Wondering why there is such a difference for powerpc!

Thanks,
Bruno


> On Thu, 1 Apr 2010 18:35:30 Stephen Rothwell wrote:
> > Hi Jiri,
> > 
> > On Thu, 1 Apr 2010 08:18:43 +0200 (CEST) Jiri Kosina
> > <jkosina@suse.cz> wrote:
> > >
> > > On Thu, 1 Apr 2010, Stephen Rothwell wrote:
> > > 
> > > > After merging the final tree, today's linux-next build (powerpc
> > > > allyesconfig) failed like this:
> > > > 
> > > > drivers/hid/hid-picolcd.c: In function
> > > > 'picolcd_debug_reset_write': drivers/hid/hid-picolcd.c:1343:
> > > > error: implicit declaration of function 'copy_from_user'
> > > > drivers/hid/hid-picolcd.c: In function
> > > > 'picolcd_debug_eeprom_read': drivers/hid/hid-picolcd.c:1407:
> > > > error: implicit declaration of function 'copy_to_user'
> > > > 
> > > > Caused by commit 9bbf2b98ba11d00bd73e3254e15cfe17ccaff6ba ("HID:
> > > > add experimental access to PicoLCD device's EEPROM and FLASH").
> > > > Using copy_ {to,from}_user requires the include of
> > > > linux/uaccess.h.
> > > > 
> > > > I have reverted that commit for today.
> > > 
> > > Hmm, on which arch did this bomb out? I wonder why it is building
> > > fine for me.
> > 
> > PowerPC (see above).  It could also be some interaction with another
> > tree in linux-next.
> > 
> > > Anyway, I have added the include, as it is obviously correct(tm),
> > > thanks for reporting it.
> > 
> > Thanks.
> > 
