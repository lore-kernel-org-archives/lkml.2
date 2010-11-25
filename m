Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab0KYNv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 08:51:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43956 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab0KYNvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:51:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pd+e6L++FJO7HWrwPs98jJixkKxftfGta4FeSwgGD/3I2AJqMKFG/nP8DbExfpwvtd
         ebFYgrZNnwpC9W0I/Sn2gF9sNcHJLtAt2+TTbHoKTvflxW27O+VK6floUio6GTmwI9VG
         Yf7JwFFIgarszEDJTXti94RDszwPh8p7russU=
MIME-Version: 1.0
In-Reply-To: <20101125104817.GA31779@oksana.dev.rtsoft.ru>
References: <1290443565-20766-1-git-send-email-mkl0301@gmail.com>
	<1290443565-20766-3-git-send-email-mkl0301@gmail.com>
	<20101124161122.GA15902@oksana.dev.rtsoft.ru>
	<AANLkTimMEALmH08RKQet_MGiyEFYpD2kVtPtmKJpmhtZ@mail.gmail.com>
	<20101125104817.GA31779@oksana.dev.rtsoft.ru>
Date: Thu, 25 Nov 2010 21:51:23 +0800
Message-ID: <AANLkTikDFe55ksjia85WSecsUw+VQpYnVO-xCkhdmcYO@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: cns3xxx: Add architecture definition for
 EHCI/OHCI controller
From: Lin Mac <mkl0301@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/25 Anton Vorontsov <cbouatmailru@gmail.com>:
> On Thu, Nov 25, 2010 at 03:25:38PM +0800, Lin Mac wrote:
> [...]
>> >  #include <linux/module.h>
>> >  #include <linux/io.h>
>> >  #include <linux/delay.h>
>> > +#include <asm/atomic.h>
>> It's not necessary for mach/pm.h already included it, right?
>
> Technically, it's not necessary. But in Linux we don't rely on
> headers including other headers. Think that someday mach/pm.h
> may not include asm/atomic.h, so the build will break.
>
> Thanks,

Get it. So should I re-submit all 3 patches, or just the last one?

>>
>> >  #include <mach/system.h>
>> >  #include <mach/cns3xxx.h>
>> >  #include <mach/pm.h>
>> > @@ -117,3 +118,6 @@ int cns3xxx_cpu_clock(void)
>> >        return cpu;
>> >  }
>> >  EXPORT_SYMBOL(cns3xxx_cpu_clock);
>> > +
>> > +atomic_t usb_pwr_ref = ATOMIC_INIT(0);
>> > +EXPORT_SYMBOL(usb_pwr_ref);
