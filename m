Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab0LLOD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 09:03:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37304 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab0LLODy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 09:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PmK8FRxTyWLyDrAreJjfpCQEhnJEhpncdc+c+EGeN/T56a9e5Au7VjMVaYrRFqx2oc
         4+5g+ssIlld/nXVhqDhnIlzx2CrXxtNKyK5NQWrZOTLmeW0dG+EBMn2136YeWUU6eJt5
         CPEtLJ1KKPWXVlErIukhXBzSdpaHHFoyQ25EI=
MIME-Version: 1.0
In-Reply-To: <20101212135224.GA31812@void.printf.net>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
	<20101208115510.GD10998@console-pimps.org>
	<AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
	<AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
	<20101209064751.GA21128@void.printf.net>
	<AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
	<20101209160157.GA28586@void.printf.net>
	<AANLkTim3Rj2tTbqvT8nM4L=p=Wx8bdOnGq=EDv+cs02g@mail.gmail.com>
	<20101211192320.GA24430@void.printf.net>
	<AANLkTin5aVPz5Y=jS89V00XS=rje3gqeUb2VTYt2A_9=@mail.gmail.com>
	<20101212135224.GA31812@void.printf.net>
Date: Sun, 12 Dec 2010 14:03:52 +0000
Message-ID: <AANLkTinMYeWNLu8e7xyBTvjmeFMsJ5sDGtsCesu04d4K@mail.gmail.com>
Subject: Re: [PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 1:52 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi Will,
>
> On Sun, Dec 12, 2010 at 10:57:44AM +0000, Will Newton wrote:
>> > drivers/mmc/host/dw_mmc.c: In function ‘dw_mci_pull_data64’:
>> > drivers/mmc/host/dw_mmc.c:998: error: implicit declaration of function ‘__raw_readq’
>> >
>> > because arch/arm doesn't implement raw versions of these 64-bit accesses.
>> > I'm surprised that this driver hasn't been compiled on ARM before!  What
>>
>> That particular bit of code has been added since it was last built for
>> arm. Our architecture can do 64bit accesses so we implement readq.
>> Unfortunately there doesn't seem to be a sane way to conditionalize
>> code for architectures that have or don't have readq, so I suspect
>> I'll have to just remove that branch of the if statement for now.
>
> (Russell, thanks for the excellent explanation.)
>
> Other drivers (MTD, gpio/basic_mmio_gpio.c, fs/fuse, pcm_oss.c)
> conditionalize uses of {read,write}q on BITS_PER_LONG >= 64, so
> something like this:

I don't think that's going to work, BITS_PER_LONG isn't equivalent to
"can do 64bit IO accesses", at least it isn't on our architecture. x86
is in the same situation it would appear, although x86 does explicitly
#define readq so it may be possible to #ifdef on that?
