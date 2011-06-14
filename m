Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1FNLRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 07:17:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35451 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1FNLRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 07:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FnicpKkVhQ4zY3fgxD9V3SWf1aucd0TazFniSo0u62z9EGGS+DdeEfbH4iTeJgKoop
         MGdkP6wwn0PFuiVCPzltqZZek6kU3guymHBI7bPCXElbVKmC/cd0hhimBMM6vnwU/qX0
         QM+F8E0M6X691WEi0ejwp1wx325KPSsa+zNcs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1106141202531.11814@ionos>
References: <BANLkTi=urdW0WBHcVbVzDwwLzupP_Vh2EA@mail.gmail.com>
	<alpine.LFD.2.02.1106141202531.11814@ionos>
Date: Tue, 14 Jun 2011 13:17:10 +0200
Message-ID: <BANLkTim5hRZ9SromkAnY=Nbp=ntorypbjg@mail.gmail.com>
Subject: Re: chained irq handler problems
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 12:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 12 Jun 2011, Manuel Lauss wrote:
>> My question is: what are the differences in interrupt handling between the
>> "traditional" handler and the cascade handler case?
>> I also noticed that the cascade irq (the muxer irq line to the cpu) is not
>> disabled when the interrupt is serviced. Is this by design?
>
> The normal handler, which should btw never ever be setup from an
> startup callback, deals with the irq chip functions (mask, ack, eoi)
> which are assigned to that irq line. The chained handler is called
> directly from the low level entry code and bypasses the standard
> handling mechanism. That means no chip functions are called. If your
> irq chip of the primary line requires e.g. an ack, then this needs to
> be done explicitely in the chained handler itself.

I added calls to disable/enable the cascade around the call
to generic_handle_irq() and now it works (no ack necessary since
the cascade is set up as level-triggered).

Thanks!
        Manuel Lauss
