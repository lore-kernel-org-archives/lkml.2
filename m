Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0LJEry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 23:47:54 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44075 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab0LJErw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 23:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uhYtSYeRGLAh4kOrSHqQtAI9g6j5X+0aEhDu8HEnlsfHsBcCNw5wRYN22/dlbVfSvw
         tWG9a7xiFK3DFPVEVpESIO17L/fMH5JFQPqgn6PCEf/RdMIgfrmKYyF7O3fBTv/bsphw
         96qJg1ebFS7xRF0dK2ztkI4h42BAuSXUNPIgI=
MIME-Version: 1.0
In-Reply-To: <4C861A09.5020203@ladisch.de>
References: <AANLkTiktFQWvz-TzewKYEd1wtEbe3cVFjFca4dFtUTCV@mail.gmail.com>
	<4C85F0E3.2050908@ladisch.de>
	<AANLkTi=-=88y=6kvV-WC3b5Pw7cf_ZoPaxhUnYugQK81@mail.gmail.com>
	<4C860043.9000501@ladisch.de>
	<AANLkTimbDOb-iJgRmpEb29GVfP-K0_6TtvPSF7eK-2ts@mail.gmail.com>
	<4C861A09.5020203@ladisch.de>
Date: Fri, 10 Dec 2010 10:17:51 +0530
Message-ID: <AANLkTimPU05Fs0VA4-u1aAxqv=AH+jNb+1S3OObXGNoD@mail.gmail.com>
Subject: Re: Hungry for hardware timers
From: Jaswinder Singh <jaswinderlinux@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 7, 2010 at 4:25 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Jaswinder Singh Rajput wrote:
>> As per dmesg([    0.325958] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0)
>> so IRQs are like this :
>> HPET T0 : 2
>> HPET T1 : 8
>> HPET T2 : 0
>
> "0" means that the BIOS did not initialize it.  In this case, the driver
> will initializes it when accessed, with the first supported IRQ above 15.
> On your HPET's T2, this is IRQ 20.
>

I have used /dev/hpet as periodic interrupt and it works great but
settings for HPET_T2_CMP will be like this :

10 micro-seconds :  110 /* 0.00001 sec  */
100 micro-seconds : 1230 /* 0.0001 sec   */
1 milli-second : 13800 /* 0.001 sec    */
10 milli-seconds : 142580 /* 0.01 sec     */
100 milli-seconds : 1431150 /* 0.1 sec      */
1 second : 14317330 /* 1 sec        */
10 seconds : 143179330 /* 10 sec       */
100 seconds : 1431799400 /* 100 sec      */

I do not have a oscilloscope so I am measuring it by using printks.
I am curious, Why it is irregular.

I am looking for one more timer interrupt handler, how can I get one
more interrupt handler for user.

Thanks,
--
Jaswinder Singh.
