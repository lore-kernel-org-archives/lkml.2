Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab1BXT7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:59:21 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57210 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab1BXT7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:59:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pxOHNLVoJN97kH+yH7nKbZqtHpYB5P6EiL+Vfgi8C4FcQM/R0JXbYyglimCiwNf2Rw
         dKyLEPqc5/vdKqs++L27vmgiEuGNCcYbcFQPLUhqdFo8YYVsgcusNN3RFwZwPsyKVf0H
         ldcdMUHu5ZYsgEGtjmXwkCmTn7lrHwGgtXG8g=
MIME-Version: 1.0
In-Reply-To: <20110224171209.GE7925@suse.de>
References: <1298539998-6422-1-git-send-email-marek.belisko@open-nandra.com>
	<20110224171209.GE7925@suse.de>
Date: Thu, 24 Feb 2011 20:58:52 +0100
Message-ID: <AANLkTimTePRqSZ5=oJPrEM1cdu0zNPmWGfm_AbN3OdiJ@mail.gmail.com>
Subject: Re: [PATCH] staging: gma500: Fix compilation error.
From: Belisko Marek <marek.belisko@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: alan@linux.intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Feb 24, 2011 at 6:12 PM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Feb 24, 2011 at 10:33:18AM +0100, Marek Belisko wrote:
>> This patch will fix following compilation error:
>> drivers/staging/gma500/psb_drv.c:1635: error: unknown field ‘pci_driver’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1636: error: unknown field ‘name’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1636: warning: initialization from incompatible pointer type
>> drivers/staging/gma500/psb_drv.c:1637: error: unknown field ‘id_table’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1637: warning: excess elements in union initializer
>> drivers/staging/gma500/psb_drv.c:1637: warning: (near initialization for ‘driver.kdriver’)
>> drivers/staging/gma500/psb_drv.c:1638: error: unknown field ‘resume’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1638: warning: excess elements in union initializer
>> drivers/staging/gma500/psb_drv.c:1638: warning: (near initialization for ‘driver.kdriver’)
>> drivers/staging/gma500/psb_drv.c:1639: error: unknown field ‘suspend’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1639: warning: excess elements in union initializer
>> drivers/staging/gma500/psb_drv.c:1639: warning: (near initialization for ‘driver.kdriver’)
>> drivers/staging/gma500/psb_drv.c:1640: error: unknown field ‘probe’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1640: warning: excess elements in union initializer
>> drivers/staging/gma500/psb_drv.c:1640: warning: (near initialization for ‘driver.kdriver’)
>> drivers/staging/gma500/psb_drv.c:1641: error: unknown field ‘remove’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1641: warning: excess elements in union initializer
>> drivers/staging/gma500/psb_drv.c:1641: warning: (near initialization for ‘driver.kdriver’)
>> drivers/staging/gma500/psb_drv.c:1643: error: unknown field ‘driver’ specified in initializer
>> drivers/staging/gma500/psb_drv.c:1643: warning: excess elements in union initializer
>> drivers/staging/gma500/psb_drv.c:1643: warning: (near initialization for ‘driver.kdriver’)
>> drivers/staging/gma500/psb_drv.c: In function ‘psb_init’:
>> drivers/staging/gma500/psb_drv.c:1664: error: implicit declaration of function ‘drm_init’
>> drivers/staging/gma500/psb_drv.c: In function ‘psb_exit’:
>> drivers/staging/gma500/psb_drv.c:1669: error: implicit declaration of function ‘drm_exit’
>>
>> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
>
> Odd, how come I'm not hitting these in the staging-next tree?  Is it
> because an api changed in the DRM layer in the linux-next tree?
Yes DRM api was changed:
commit 8410ea3b95d105a5be5db501656f44bbb91197c1
Author: Dave Airlie <airlied@gmail.com>
Date:   Wed Dec 15 03:16:38 2010 +1000

    drm: rework PCI/platform driver interface.

Introduce union kdriver which encapsulate pci_driver struct.
That's cause of error in gma500.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
