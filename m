Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab0FGV22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:28:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56606 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0FGV21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cDKMo6pifomMpXUY49V1kvMIMDbk0a6pRfIwTUPIn+MF7EYxKpUVJAwYYy8OLdnqDm
         SCmIYchHumharhftSQtfPGi36pBalL1BKWnA6pM4K8yVxkDgRq6Aw9Blv9zENzVcZR0U
         jQQ0T+JweUosscgdUn6SaVHuZUGykaFDfIBZg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006071440520.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	<AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	<20100605151031.2d562268@hina.wild-wind.fr.eu.org>
	<alpine.LFD.2.00.1006051732270.2933@localhost.localdomain>
	<AANLkTimlSBEhl58CNuScKjxbqdTwTYgqo7vrHTcd1x9G@mail.gmail.com>
	<alpine.LFD.2.00.1006051915290.2933@localhost.localdomain>
	<AANLkTimcB9vRqnNYyBh6hjHXZHcmFvw72MZUEIGfeexq@mail.gmail.com>
	<alpine.LFD.2.00.1006052155100.2933@localhost.localdomain>
	<AANLkTik2so7osQJFq6NRaIFK2GVLURVozOqSsejd1K0F@mail.gmail.com>
	<alpine.LFD.2.00.1006062228120.2933@localhost.localdomain>
	<1275914058.2818.8.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006071440520.2933@localhost.localdomain>
Date: Mon, 7 Jun 2010 23:28:23 +0200
Message-ID: <AANLkTilPhof5cnhBCXSzKJSnWl6Vuu2fRts2pBBBNl6K@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
	interrupt handlers
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Esben Haabendal <eha@doredevelopment.dk>, linuxppc-dev@ozlabs.org,
       Marc Zyngier <maz@misterjones.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, joachim.eastwood@jotron.com,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 5:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

> Maybe you understand now, why I was pretty sure upfront, that your
> approach was wrong even without knowing all the gory details ? :)

I understand.  There is a better solution, which is to use threaded
interrupts where needed.

But I must confess that I am disappointed that you still fail to see
how the pca953x
patch actually eliminates the need for serialization. But I don't
think there is much
point in going on about that.

The phy driver should be rewritten to use a threaded handler, it will
solve my particular problem.
And in the meantime, I have been promised to get the phy interrupts ofloaded
to real CPU interrupt lines :-)

Oh, I still think that the disable_irq_nosync documentaiton is misleading.
Functions that are allowed in a particular context should not call functions
that are not allowed to be called in that context. But now I know :-)

/Esben
-- 
Esben Haabendal, Senior Software Consultant
DoréDevelopment ApS, Ved Stranden 1, 9560 Hadsund, DK-Denmark
Phone: +45 51 92 53 93, E-mail: eha@doredevelopment.dk
WWW: http://www.doredevelopment.dk
