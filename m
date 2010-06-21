Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0FUUh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:37:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38553 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119Ab0FUUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=cY7/8mD+zH+sm9fX4mA5YiWTqNSupZNC50eRM41689dUj7qwJyJCbXn4vzcCvUpbgc
         CcirbBYX1YkFAJmOc1Cgg6/inj42ROvKJke0b8m33Z+r2ECNDzQiw2uf6H6su1vzvBVz
         ME9Q6UYCueUy0uRMVP7gljk/vQS26HDf3rnfk=
MIME-Version: 1.0
In-Reply-To: <1277151410.5409.33.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan> <1276806785.20754.8.camel@maxim-laptop> 
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info> <1276856142.9114.1.camel@maxim-laptop> 
	<20100618134930.124225d4fsi8w1fk@naisho.dyndns.info> <1276859156.19554.2.camel@maxim-laptop> 
	<AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> 
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> 
	<1277032723.9555.12.camel@maxim-laptop> <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> 
	<1277151410.5409.33.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 13:37:04 -0700
Message-ID: <AANLkTin3fKn0_4mrhmPOlTeN--1EZbKECGF3NVdh9h1t@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 1:16 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Luis, let me explain again, exactly the situation:
>
> First of all AR5001 and AR5001X devices (former was usualy listed as
> AR2425, and I have it, later I don't know about much), don't work well
> with ASPM L0s enabled.

Thanks for the clarification. David, do you see this as well on your end?

> I told that many times, but I tell again.
> As soon as card it put on medium to high transmit load
> (for example even if transmission consists mostly of TCP ACK packets),
> it dies.
>
> Usualy it will stop transmitting, and then after few seconds it will
> send RXORN intrrupt to the host, even though the channel was idle.
> (Tested by sending a stream of UDP packets on channel that is neighbor
> free).
>
> I didn't see it, but some users reported seeing jumbo frames at this
> time as well.
> Overall it doesn't matter because card just goes south.
>
> A reset sometimes brings card to life, sometimes causes another storm of
> RXORN and sometimes just results in quiet dead card.
> A next reset might bring it to life, or not.
>
> Card (at least mine) advertises its as a 'pre pci 1.1 device'.
> Therefore if I enable CONFIG_PCIEASPM, the pci core will automaticly
> disable ASPM (both L0s and L1) on this card.
> I won't be surprised that windows does the same.

I am not sure when L0s was enabled as per the spec as mandatory, I
thought it was optional. Interesting to hear this behavior on Linux
with CONFIG_PCIEASPM. That Kconfig description and code really need
some spit shining.

> Therefore the patch I sent it useless because it only works when
> CONFIG_PCIEASPM is enabled.

How so ? Your patch disables L0s, I can use ASPM with L0s and L1 with
or without CONFIG_PCIEASPM. If I added your calls to ath9k I would
disable L0s.

  Luis
