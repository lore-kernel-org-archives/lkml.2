Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab0FUUja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:39:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55068 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab0FUUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Xh3gjTy2ypNrW7xTcfDKH7Ilk8tW/SDDLY7x8soyV/u1NIpAI7jl+9MQjWLhdl6sWW
         ssKOKrvuK8/uDaXIXh5HyF1OSAh76Z3XY0/LzBy+PqhlVFPxBzsx0G4l6HeG76E/Lv1a
         P6Etferi4ZOBwWZkLXCNf8HPmECJoo7ry8u7c=
MIME-Version: 1.0
In-Reply-To: <20100621233333.21262abjfxl8j1xc@hayate.sektori.org>
References: <20100528100901.14580.1322.stgit@fate.lan> <1276806785.20754.8.camel@maxim-laptop> 
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info> <1276856142.9114.1.camel@maxim-laptop> 
	<20100618134930.124225d4fsi8w1fk@naisho.dyndns.info> <1276859156.19554.2.camel@maxim-laptop> 
	<AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> 
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> 
	<1277032723.9555.12.camel@maxim-laptop> <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> 
	<1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 13:39:07 -0700
Message-ID: <AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 1:33 PM, Jussi Kivilinna
<jussi.kivilinna@mbnet.fi> wrote:
> Quoting "Maxim Levitsky" <maximlevitsky@gmail.com>:
>
>> Card (at least mine) advertises its as a 'pre pci 1.1 device'.
>> Therefore if I enable CONFIG_PCIEASPM, the pci core will automaticly
>> disable ASPM (both L0s and L1) on this card.
>> I won't be surprised that windows does the same.
>>
>
> Even if CONFIG_PCIEASPM compiled in, ASPM code can be disabled by user with
> pcie_aspm=off option, leaving BIOS-enabled L0s on.

Last I reviewed CONFIG_PCIEASPM won't buy you *anything* other than
debugging knobs. With it you can force all devices to enable ASPM
completely on or disable it. Both of which I think are not really
useful and instead should be done in userspace given that if you are
testing ASPM you likely want to test only one one device and its
respective root complex, not all at the same time.

  Luis
