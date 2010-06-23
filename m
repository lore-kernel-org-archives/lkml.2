Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0FWRtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:49:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0FWRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bHiIw371l3swaxAwOxGz/hlkluJq54sa19Pb0XVBAxm02Qb8GSNOmYIATkvt3xNVTJ
         iqCk/5k6PVEVf6iD1Vvhzq2XTaT5TsKx8uUyjbyezV/P8vg6fCdr1dhOZiLSF/xSpGrW
         YwKzrnf663m8COr6r0IaTNwEJ5AN11DmB+Ya0=
MIME-Version: 1.0
In-Reply-To: <4C20B364.9060405@blueyonder.co.uk>
References: <4C20B364.9060405@blueyonder.co.uk>
Date: Wed, 23 Jun 2010 18:49:48 +0100
Message-ID: <AANLkTikiVMjIcnXrCVS6UK1ln1NVUZc3pjSGIIFwSJkg@mail.gmail.com>
Subject: Re: 2.6.35-rc3 E-MU 0404 USB problem
From: James Courtier-Dutton <james.dutton@gmail.com>
To: sboyce@blueyonder.co.uk
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 June 2010 13:58, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
> I have an application using the on-board sound card mic which should send
> it's data to the USB card for relay to a Sofweare Defined Radio as 2
> quadrature signals digital (I/Q) for transmission.
> On the receiving side it can take data from the Radio at up to 192K sample
> rate --> program --> Speaker on the on-board sound card - that works fine.
> Transmit fails, dmesg output with 48K sample rate set is:-
> [509686.177169] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks sample
> rate attribute bit, cannot set.
> [509686.187920] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks sample
> rate attribute bit, cannot set.
> [509686.266905] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509686.330901] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509686.353775] ALSA sound/usb/clock.c:214: 6:2:7: endpoint lacks sample
> rate attribute bit, cannot set.
> [509686.394898] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509686.458886] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509686.522874] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509823.078594] ALSA sound/usb/clock.c:214: 6:2:3: endpoint lacks sample
> rate attribute bit, cannot set.
> [509823.091571] ALSA sound/usb/clock.c:214: 6:2:1: endpoint lacks sample
> rate attribute bit, cannot set.
> [509823.146811] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509823.202679] ALSA sound/usb/clock.c:214: 6:2:7: endpoint lacks sample
> rate attribute bit, cannot set.
> [509823.210807] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509823.274792] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509823.338782] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> [509823.402783] ALSA sound/usb/mixer.c:2051: status interrupt: c0 0e
> Regards
> Sid.
> --

This device uses a global clock rate according to the data sheets.
So, record rate must equal playback rate.
