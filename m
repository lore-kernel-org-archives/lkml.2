Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0JPJnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 05:43:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61719 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab0JPJnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 05:43:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hAyXurAXoVN/27CAgtoJ3QLqP46KqJ4hGJzdRrf5WMea+LfWWCJ1rCAYaS46YDI5jD
         uJIY68u3R6ZG50ukve+Am/uSck6pIaxNdlpDXGuG9VDxXLYiKgICWJvWtS6FfUf6/+YF
         P5I8XmS4zFFOtfg7GnarWpT9j0ZiUsCldI1Vs=
MIME-Version: 1.0
In-Reply-To: <1287196789.2370.3.camel@pasglop>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
	<20101008234448.GD10975@n2100.arm.linux.org.uk>
	<20101009000046.GA30616@kroah.com>
	<1287196789.2370.3.camel@pasglop>
Date: Sat, 16 Oct 2010 12:43:42 +0300
Message-ID: <AANLkTi=a4XOfOZ=cPey5eK2DXUY3eXo=b-rOUVKz1n2C@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/16 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Fri, 2010-10-08 at 17:00 -0700, Greg KH wrote:
>>
>> But you can't expect that you make this change, and not fix up the
>> drivers, and people would be happy, right?  The rule for API changes
>> like this, or anything, is that the person making the change fixes the
>> other drivers, and that seems to be the issue here.
>>
>> Any pointers to patches where people have fixed up the drivers?
>
> Greg, this is true for normal API changes. In this case, this is silent
> data corruption, I think Russell is absolutely right. That exact same
> issues have been giving me nightmares on powerpc, mostly due to
> (fortunately extremely rare) broken chipsets doing non coherent DMA on
> processors that do not allow you architecturally to double map memory
> with different attributes.

Yes, but the kernel could have a mechanism, like the constant memory
allocator so that people can configure a certain amount of RAM, like
CONFIG_CMA_RESERVE_SIZE, and then drivers could request blocks from
there which are not mapped as kernel memory. The constant memory
allocator could map them at the same time they are requested by
drivers with different attributes.

-- 
Felipe Contreras
