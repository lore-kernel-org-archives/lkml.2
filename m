Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0FERBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:01:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:43356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab0FERBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Pq4wN6ozGFP4qVTCgfeQd8Tz4PWiOJ/L1om9b+NimEDT6yHuqP855/lhASh8SyVc5t
         7xDSDKlOTYX3OJNomlID3i8pDcGGwlst5lM3nDiNcg1UYcafXIut3qgYMp0oL66MAwO8
         Y9j6BdcgfXSw7Tgu8CkOkXsaquGsignbxy1Xc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	<AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	<20100605151031.2d562268@hina.wild-wind.fr.eu.org>
	<alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
Date: Sat, 5 Jun 2010 19:01:47 +0200
Message-ID: <AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
	interrupt handlers
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@misterjones.org>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 5:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 5 Jun 2010, Marc Zyngier wrote:
>> You may want to give request_any_context_irq() a try (available since the
>> latest merge window). It still requires your driver to be changed, but it
>> should then work in both threaded and non-threaded cases.
>
> And it nicely annotates that somebody looked at the driver in
> question. That's the rule of least surprise and does not impose checks
> on the fast path.

What in particular should I be looking for in a driver before changing
from request_irq() to request_any_context_irq() ?

As for not checking in the fast path, it should be noted that this is "only"
in handle_nested_irq(), which is only used in few interupt controller
drivers, all of which I assume are generally not considered very "fast".

Unless all interrupt handlers should be rewritten to be able to in both
thread and interrupt context, I fail to se the conflict between the patch
proposed and the work being done on request_any_context_irq().

/Esben
