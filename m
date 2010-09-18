Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0IRIuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 04:50:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59336 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab0IRIuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 04:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NiNR9pwVw8bRZ2N8jO0UUWEjs0Ry6MA08aShvp5sq+xXQd4fHjRVBpUXmFsypJ9W7a
         HHUX6SbyUIE6xWRrwEfJ5uWCeQAtydz6YhbITYHhXj0m6vT7eOituUvcNDAeGr086sZk
         KX4szw202CVrZyr85mnsnMEQxke5Bn7Q8OI0M=
MIME-Version: 1.0
In-Reply-To: <201009180954.52965.wolfgang@iksw-muees.de>
References: <711BBECDEF81BA439A6038E213C1DF140957B9F8@ism-mail03.corp.ad.wrs.com>
	<711BBECDEF81BA439A6038E213C1DF140957BD3D@ism-mail03.corp.ad.wrs.com>
	<AANLkTimbHMvgsT809X44zAnYQEvSEbCtNc-eqHuxW8uK@mail.gmail.com>
	<201009180954.52965.wolfgang@iksw-muees.de>
Date: Sat, 18 Sep 2010 16:50:20 +0800
Message-ID: <AANLkTikj01UhkiVrGJg4jgoOtXZ6dJjnwTsskDUVLD_H@mail.gmail.com>
Subject: Re: USB: free coherent buffer into atomic context
From: Ming Lei <tom.leiming@gmail.com>
To: =?ISO-8859-1?Q?Wolfgang_M=FCes?= <wolfgang@iksw-muees.de>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC linux-kernel

2010/9/18 Wolfgang Mües <wolfgang@iksw-muees.de>:
> Hi,

Thanks for your reply.

>
> Am Freitag, 17. September 2010 16:59:25 schrieb Ming Lei:
>> The warning only means dma_free_coherent is called with irq disabled.
>> It is not very difficult to fix the warning in usb hcd, but I need to know
>>  why the WARN_ON below is added into dma_free_coherent.
>>
>>            WARN_ON(irqs_disabled());
>>
>> Anyone know the reason?
>
> Hmm... Coherent buffers are ment to be kept for the whole time a driver

Documentation/DMA_API.txt

        Consistent memory is memory for which a write by either the
        device or the processor can immediately be read by the processor
        or device without having to worry about caching effects.

IMO, it is not necessary for a coherent buffer to be kept for
the whole time a driver operates on a device. Also, coherent buffer
is very limited in some arch(such as ARM), maybe we should use it
more dynamically, instead of keeping it for long time.

> operates on a device. If such a buffer is freed in an interrupt context (== a

irqs_disabled() doesn't mean the buffer is freed in an interrupt context.

> momentary action), this is most likely a bug in the driver. At least it is a
> misuse of the concept of coherent buffers.

If it is only a misuse, seems WARN_ON can be removed.

Sorry, I still don't get the real reason why WARN_ON(irqs_disabled()) is
added in dma_free_coherent.

-- 
Lei Ming
