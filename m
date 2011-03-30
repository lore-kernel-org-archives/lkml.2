Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1C3QLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:11:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54948 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1C3QLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L+u4AxD7oTKCjZvphgId1b6gjqpdPKsABiiT/bf9m4bTbCwAWPSJK647x4k1wBs40P
         0ka62MX6pB+4F930uWE4c4gJImUuKaxC3Hjo/chK5EaIwCetRd6qmizZPZ9lb6mNSgvf
         qlvdTmntIWfLEi7tFU2YXPInI9XW8zjGv/Ovg=
MIME-Version: 1.0
In-Reply-To: <20110330092307.4a8deb79@bike.lwn.net>
References: <AANLkTim3eMR+5VQT9Cbew70bLZ_3P7eo3FXx_TxMuP1=@mail.gmail.com>
	<20110330092307.4a8deb79@bike.lwn.net>
Date: Wed, 30 Mar 2011 13:11:40 -0300
X-Google-Sender-Auth: pBg-jtl9Lw0c4FiYzfKlsIALjTU
Message-ID: <AANLkTimkss168HfsPtJPpF1MiYAbHty3csW=R10P+=JA@mail.gmail.com>
Subject: Re: Help with dma on PCI driver
From: Luis Rossi <luisf.rossi@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your answer

Sorry for the code. I am not a kernel developer, i am a hardware
engineer, but i need to test a system i am designing. Most of the code
wasnt writen by me. I got it from another guy, the part that i wrote
so far was the one related to pci_alloc_constants. I will remake the
whole code soon to make it more readable. I was just testing some
concepts with it. I am trying to learn how to write  a driver based on
LDD3 and Linux Essential, but i was having a hard time. For now i
could find my problem. It was a dumb mistake and not realated to
kernel development. I forgot to allocate my structure.... so it was a
pointer to nothing.. But as you pointed me some problems.. just to
make sure.. should i stop the inti function on the device register,
and make all the rest inside probe? It makes a lot of sense as the
rest should be called just if the device is connected...

Thank you!!

On Wed, Mar 30, 2011 at 12:23 PM, Jonathan Corbet <corbet@lwn.net> wrote:
>
> On Wed, 30 Mar 2011 07:07:32 -0300
> Luis Filipe Rossi <luisf.rossi@gmail.com> wrote:
>
> > I am developing a driver for a custom PCI board. I am following the
> > example on Essential Linux Device Drivers, but when i am calling the
> > pci_alloc_consitent i get the following error:
> > Mar 29 15:18:42 luis-desktop kernel: [ 4520.075823] BUG: unable to
> > handle kernel NULL pointer dereference at 00000004
>
> Your source was horribly mangled, which is likely to reduce the number of
> responses you get.  I've not had the time to look at it in great detail,
> but I will say that the assumption that the PCI device is already probed
> and registered immediately after the pci_register_driver() call is
> dangerous at best.  Things like dma_descriptor_setup() should be called in
> your probe routine (or even later, when you actually need the buffer)
> rather than in your module init function.
>
> There's a lot of other issues with this driver, but that's the one I would
> look first at for the resolution of this particular crash.
>
> jon



--
Luís Filipe Rossi
Electrical Engineer
Biomechatronics Lab. / Grupo de Sensores Integráveis e Sistemas
Escola Politécnica
Universidade de São Paulo
Cel. +55 (11) 7662-9234
