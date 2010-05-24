Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0EXKKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:10:16 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:47113 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0EXKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:10:14 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2010 06:10:14 EDT
Message-ID: <4BFA4F52.1090004@ge.com>
Date: Mon, 24 May 2010 11:05:06 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alexander Kurz <linux@blala.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers	grouped
 by bustype.
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com>
In-Reply-To: <20100514190142.GA2505@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, May 08, 2010 at 12:21:45PM +0400, Alexander Kurz wrote:
>   
>> This is a new Kconfig and Makefikes for staging/comedi.
>> The drivers are sorted now alphabetically in sub-menus
>> depending on the bustype.
>> I did some basiy dependancy tests, but there still may
>> be a lot that I missed.
>>
>> >From c53596606230a4a8ee7dd76b48cf6b10a059e8f7 Mon Sep 17 00:00:00 2001
>> From: Alexander Kurz <linux@kbdbabel.org>
>> Date: Fri, 7 May 2010 22:46:17 +0200
>> Subject: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers grouped by bustype.
>>  PC/104-drivers went into ISA,
>>  PC/104+ went into PCI,
>>  Drivers without a bustype went into "misc".
>>  In doubt drivers supporting both ISA/PCI went into PCI.
>>  Drivers without any detailed hardware info went into ISA, e.g. fl512.c
>>  Some NI drivers are used by other NI drivers from different bustypes
>>  are grouped seperately in NI_COMMON.
>>
>> Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
>> ---
>>  drivers/staging/comedi/Kconfig             | 1274 +++++++++++++++++++++++++++-
>>  drivers/staging/comedi/drivers/Makefile    |  245 +++---
>>  drivers/staging/comedi/kcomedilib/Makefile |    2 +-
>>     
>
> Wow.  Is this something that we really want?  That's a lot of new
> Kconfig options, and while it seems like it makes sense, I would like to
> get the comedi developers opinion here.
>   

Having recently had cause to use the comedi_parport driver on a PowerPC
board, I can say I'm very much in favour of this patch or one like it. I
had to modify the makefile so that it didn't require all the PCI drivers
to be built (some of which were failing - I really didn't have time to
fix them, sorry) to use a driver that doesn't necessarily have any PCI
dependency.

Even if there are a few dependencies missing, it seems like a step forward.

Martyn

> Frank?  Ian?
>
> thanks,
>
> greg k-h
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>   


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

