Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab0EGQKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:10:36 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51891 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab0EGQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:10:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KC7cQJ+z2tT2SGoJ9SnrYsTGTpjkEXICm5IiM//gnkx9wfu17F9m7vWbsJs1Xbw1td
         uC0joeA8Xhy8Ta88e3PV6r9Zz4eWHPFjspSEHhDIeCXMiSNPap3Dc+91cUs8UM762Qty
         KRn8ksAMt1xGnnmotQoceMB12yw7FBCRybIS0=
MIME-Version: 1.0
In-Reply-To: <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
	 <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
Date: Fri, 7 May 2010 18:10:28 +0200
Message-ID: <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: jassi brar <jassisinghbrar@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>,
       Dan Williams <dan.j.williams@intel.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/7 jassi brar <jassisinghbrar@gmail.com>:
> On Fri, May 7, 2010 at 8:43 PM, Linus Walleij
> <linus.ml.walleij@gmail.com> wrote:
>> 2010/5/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>>>
>>> Or let me put it another way - if people are happy for Linux to support
>>> new ARM CPU architectures, but with very little attention given to DMA
>>> support on those architectures, then feel free to box the ARM platforms
>>> into a corner on DMA support - but on the understanding that _you_ will
>>> have to deal with the DMA API breakage on those architectures yourself.
>>> Because with ARM platforms not having DMA support, there's absolutely
>>> no way to run any checks what so ever on DMA when the CPU architecture
>>> support is created.
>>
>> I'm doing the best I can to meet exactly this goal. The changes done in
>> the DMA engine were done towards the end of making the DMA
>> engine support *any* DMA controller for the PrimeCells,
>
> with due respect, I think DMA Engine API is very restricting. And it is not
> just the 'async' character of it but also some desirable features like
> Circular-Linked-Buffer are missing. It may be good enough for Mem->Mem
> but is found wanting for Mem<->Dev transfers.
> I would like to see some new API defined that address reasonable
> requirements of extant platform specific implementations.

I understand these concerns, however I believe the DMAdevices/DMAengine
API can surely be refactored towards this end. Dan Williams has proved
*very* cooperative in doing changes and testing for regressions in the
DMAengine, and I see no fundamental problem with it.

Surely circular linked buffers and other goodies can be retrofitted into the
DMAengine without a complete redesign? I only see a new slave call
to support that really, in addition to the existing sglist interface.

I remember we discussed circular buffer device->device transfers with
Dan some while ago, and he was all for including that but wanted some
real-world example to go along with it.

>> So now I guess I have to make it tick on the block known as PL080/PL081
>> as well, and I'll have a try at it.
>
> I always hoped the pl080 core would be segregated out of S3C implementation,
> but for some new common DMA API.

Well, I don't see any fundamental problems with DMAengine, just wanted
extensions really.

I don't know if I'll be able to provide the nice breakout of the PL080 core
from S3C that you'd like to see but I will try to hack something up as
a proof-of-concept that the DMAengine can support the PrimeCells
found on the RealView.

Yours,
Linus Walleij
