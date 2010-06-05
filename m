Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab0FEQx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:53:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46982 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab0FEQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nsAeeNqYxeJH6cCQyhLxyayJIPpEb/Mnulo/jcTzLnRb79tVHCtEe0lKxEwEfmaqSB
         Pbrrhc5rMDr4Sm1bkaGMRtujQ3MWXBwQndwjGzgonxxYSQqBL1DaHoJ/HopdF3gwYn3q
         VngAooK+b+ft7lDryVz2Lu+lT13CTZDoYSuJ4=
MIME-Version: 1.0
In-Reply-To: <20100605151031.2d562268@hina.wild-wind.fr.eu.org>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
	<AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
	<20100605151031.2d562268@hina.wild-wind.fr.eu.org>
Date: Sat, 5 Jun 2010 18:53:53 +0200
Message-ID: <AANLkTilUGOVPBtdl2KB2nrbra8uBO8q4AX0v57hCtr_9@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
	interrupt handlers
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Marc Zyngier <maz@misterjones.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 5, 2010 at 4:10 PM, Marc Zyngier <maz@misterjones.org> wrote:
> On Sat, 5 Jun 2010 15:56:01 +0200
> Esben Haabendal <esbenhaabendal@gmail.com> wrote:
>
>> I have a board with an I2C PCA9535 chip with two PHY interrupt lines
>> hooked up to. The pca953x driver calls set_irq_nested_thread on all
>> irq's on initialization. The PHY driver then calls request_irq, and has
>> no idea that it should actually be using a threaded handler.
>>
>> With this patch, the PHY driver is able to work in this scenario
>> without changes (and so should any other driver using request_irq).
>
> You may want to give request_any_context_irq() a try (available since the
> latest merge window). It still requires your driver to be changed, but it
> should then work in both threaded and non-threaded cases.

The problem is not in "my" driver, but in the phy driver framework in this
particular case.

What is the plan here, should all drivers change from request_any_context_irq()
at some point in time?

/Esben
