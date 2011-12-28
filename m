Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1L1WRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 17:17:35 -0500
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:52450 "EHLO
	smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754616Ab1L1WRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 17:17:33 -0500
Message-ID: <4EFB957A.5070606@gmail.com>
Date: Wed, 28 Dec 2011 23:17:30 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Gustavo Padovan <padovan@profusion.mobi>,
        Andre Guedes <andre.guedes@openbossa.org>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [bluetooth] linux-3.x regression (bisected)
References: <4EF3BACA.1080405@gmail.com> <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com> <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana> <4EFA447C.3030906@gmail.com> <20111228012248.GC13870@joana> <20111228012850.GD13870@joana> <4EFA7696.6060506@gmail.com> <20111228155225.GA23292@joana> <1325090923.1965.282.camel@aeonflux>
In-Reply-To: <1325090923.1965.282.camel@aeonflux>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Ziggo-spambar: ---
X-Ziggo-spamscore: -3.6
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,FREEMAIL_FROM=0.5,PROLO_TRUST_RDNS=-3,RDNS_DYNAMIC=0.982,SPF_NEUTRAL=0.779,TW_XF=0.077
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-12-11 17:48, Marcel Holtmann wrote:

> < HCI Command: Read Local Extended Features (0x04|0x0004) plen 1
>       page 1
> > HCI Event: Command Complete (0x0e) plen 14
>       Read Local Extended Features (0x04|0x0004) ncmd 1
>       status 0x00 page 0 max 0
>       Features: 0xff 0xfe 0xff 0x7e 0x98 0x19 0x00 0x80
>
> And this is correct. Page 0 is the same as local features. Storing this
> as page 1 is the issue here. We request page 1, but we are getting page
> 0 instead. So yes, the controller is broken, but not as broken as it
> gets us false information.

By the way, while the bluetooth (2.0) spec seems to consist of a 1230 
page document that I am most certainly not going to study ...

... I couldn't help noticing that the HCI_Read_Local_Extended_Features 
command is in fact specified to return "The highest features page number 
which contains non-zero bits for the local device", and if I look at the 
above, it seems to indeed return max=0.

Is it as such not in fact the case that the dongle is spec-compliant, 
whereas it's the linux code that neglects to check that return value in 
order to make sure that it requested a valid page?

Rene.
