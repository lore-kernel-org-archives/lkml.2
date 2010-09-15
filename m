Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0IOKxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:53:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47166 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0IOKxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=CUnuY/TWB0zYzPZpr+t0j8tL0erwuXobr+sd4vxV3X50bkXJKkxKrVve+kpQ/X0qGM
         Uj0O/uFXdTQtw5qi83kXOoXOKUGQhyqAmpvTOflVtZf7TwEj7XGt5/2j2XT9VNCnxx03
         ZvR784adjNfcmVD3PzuKpJWNKKX+IhwCPbqhk=
MIME-Version: 1.0
Date: Wed, 15 Sep 2010 18:53:10 +0800
Message-ID: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
Subject: [Discussion] USB: musb-gadget: how to fix ZLP issue in musb_g_tx
From: Ming Lei <tom.leiming@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>, balbi@ti.com
Cc: "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

In another thread, Sergei pointed out there is a ZLP issue in musb_g_tx:

Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 15-09-2010 14:05, Felipe Balbi wrote:
>
> >> I didn't say it was duplicate for DMA, just too late.
>
> > how come ? we need to send ZLP before giving back the request.
>
>     Well, look at the code ionce again. We need to send ZLP *after*
> request->actual == request->length, but as the check is inserted
> after the ZLP send, ZLP *may* be sent once the first DMA completes,
> not the last.
>
> WBR, Sergei

balbi also confirmed that is is really a problem.

I also have two related questions below for the problem:

1),  why is the check for "is_dma" needed here?

      if (is_dma || request->actual == request->length) {
           ....
      }

2), why is a zlp needed in the case below?

      #ifdef CONFIG_USB_INVENTRA_DMA
                  || (is_dma && (!dma->desired_mode ||
                     (request->actual & (musb_ep->packet_sz - 1))))
     #endif

Seems no request->zero is set to ask for zlp explicitly in
the case above.

IMO, it is not difficult to give a good fix for the ZLP problem
if the two questions are clear.

-- 
Lei Ming
