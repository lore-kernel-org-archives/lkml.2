Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab0FUUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:16:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51020 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0FUUQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:16:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P+JW6psxetm56tl/6JRXTfRB5YjFjUV/60ooKDvJRzIkdU2iE8XK9NjbwF6H9p2kLv
         ZEcRu+1LT/YsipTUPuiRp49QJmnzVGdW2XR+vgYA3Cx+qUtxtR0AiJcamKERNwTqeZXL
         Yg6eymAD9jT/em3i/ezsFw/9H5gyuVNA0aKF4=
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com>
References: <20100528100901.14580.1322.stgit@fate.lan>
	 <1276806785.20754.8.camel@maxim-laptop>
	 <20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	 <1276856142.9114.1.camel@maxim-laptop>
	 <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
	 <1276859156.19554.2.camel@maxim-laptop>
	 <AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com>
	 <1276870309.23783.3.camel@maxim-laptop>
	 <1276933774.16697.11.camel@maxim-laptop>
	 <AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com>
	 <1277032723.9555.12.camel@maxim-laptop>
	 <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 23:16:50 +0300
Message-ID: <1277151410.5409.33.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis, let me explain again, exactly the situation:

First of all AR5001 and AR5001X devices (former was usualy listed as
AR2425, and I have it, later I don't know about much), don't work well
with ASPM L0s enabled.

I told that many times, but I tell again.
As soon as card it put on medium to high transmit load
(for example even if transmission consists mostly of TCP ACK packets),
it dies.

Usualy it will stop transmitting, and then after few seconds it will
send RXORN intrrupt to the host, even though the channel was idle.
(Tested by sending a stream of UDP packets on channel that is neighbor
free).

I didn't see it, but some users reported seeing jumbo frames at this
time as well. 
Overall it doesn't matter because card just goes south.

A reset sometimes brings card to life, sometimes causes another storm of
RXORN and sometimes just results in quiet dead card.
A next reset might bring it to life, or not.

Card (at least mine) advertises its as a 'pre pci 1.1 device'.
Therefore if I enable CONFIG_PCIEASPM, the pci core will automaticly
disable ASPM (both L0s and L1) on this card.
I won't be surprised that windows does the same.


Therefore the patch I sent it useless because it only works when
CONFIG_PCIEASPM is enabled.

In addition to that using the original version of this patch from Jussi
Kivilinna contains code that disables ASPM (I modified it to disable
only L0s) with or without CONFIG_PCIEASPM.

But without CONFIG_PCIEASPM it uses open coded function that should
belong to pci core.
And it is also copied from e1000 which shouldn't do that too.

Best regards,
Maxim Levitsky


