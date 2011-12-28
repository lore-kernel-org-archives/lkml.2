Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1L1XH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:07:57 -0500
Received: from senator.holtmann.net ([87.106.208.187]:40095 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1L1XHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:07:55 -0500
Message-ID: <1325113623.1965.289.camel@aeonflux>
Subject: Re: [bluetooth] linux-3.x regression (bisected)
From: Marcel Holtmann <marcel@holtmann.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Gustavo Padovan <padovan@profusion.mobi>,
        Andre Guedes <andre.guedes@openbossa.org>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Date: Wed, 28 Dec 2011 15:07:03 -0800
In-Reply-To: <4EFB957A.5070606@gmail.com>
References: <4EF3BACA.1080405@gmail.com>
	 <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com>
	 <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana>
	 <4EFA447C.3030906@gmail.com> <20111228012248.GC13870@joana>
	 <20111228012850.GD13870@joana> <4EFA7696.6060506@gmail.com>
	 <20111228155225.GA23292@joana> <1325090923.1965.282.camel@aeonflux>
	 <4EFB957A.5070606@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

> > < HCI Command: Read Local Extended Features (0x04|0x0004) plen 1
> >       page 1
> > > HCI Event: Command Complete (0x0e) plen 14
> >       Read Local Extended Features (0x04|0x0004) ncmd 1
> >       status 0x00 page 0 max 0
> >       Features: 0xff 0xfe 0xff 0x7e 0x98 0x19 0x00 0x80
> >
> > And this is correct. Page 0 is the same as local features. Storing this
> > as page 1 is the issue here. We request page 1, but we are getting page
> > 0 instead. So yes, the controller is broken, but not as broken as it
> > gets us false information.
> 
> By the way, while the bluetooth (2.0) spec seems to consist of a 1230 
> page document that I am most certainly not going to study ...
> 
> ... I couldn't help noticing that the HCI_Read_Local_Extended_Features 
> command is in fact specified to return "The highest features page number 
> which contains non-zero bits for the local device", and if I look at the 
> above, it seems to indeed return max=0.
> 
> Is it as such not in fact the case that the dongle is spec-compliant, 
> whereas it's the linux code that neglects to check that return value in 
> order to make sure that it requested a valid page?

the Linux code indeed is broken for not checking the returned page, but
it is broken for different reasons.

However the expected result from the dongle would be an error code and
not just returning page 0 instead.

And the max value just tells you about the max page value. So that the
host does not have to go ahead and read 255 pages before realizing that
there is nothing there.

Regards

Marcel


