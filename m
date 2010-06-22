Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0FVRRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:17:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:61987 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab0FVRRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=hSVvfKbBRjrciQE7COj+c0w8ejGhOnnoZIOHViS42wnzzWynpNd2UFczYAKxpOp4F1
         8f4vwfHbMH2PqcYl45P1oOCITskPPlBHaHhWN4fKe+dycEGn741VHz60MN6e4pCz4CaI
         IKsGN1hvr++x+2qi2wYOlpEJ7lrCS09CU8uSo=
MIME-Version: 1.0
In-Reply-To: <20100622165213.GA21842@srcf.ucam.org>
References: <1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> 
	<1277032723.9555.12.camel@maxim-laptop> <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> 
	<1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> 
	<AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> 
	<20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com> 
	<20100622165213.GA21842@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Jun 2010 10:17:11 -0700
Message-ID: <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 9:52 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 22, 2010 at 09:48:40AM -0700, Luis R. Rodriguez wrote:
>
>> Sure, I agree with that, but it also will enable ASPM for *all*
>> devices which have the capability which IMHO is a terrible idea for
>> users when all they want to do is enable ASPM for one device. Instead
>> I recommend users to enable ASPM for their devices selectively and
>> from userspace.
>
> Why would you only want to enable ASPM for one device?

ASPM doesn't always work for all devices even if they do advertise
ASPM capability so turning it on selectively by device is what I
recommend since otherwise you may get hangs and you will then have to
do the selective enabling. Furthermore laptops tend to disable ASPM
for cards not built-in to it, an example is Cardbus slots or internal
PCI-E slots. This is often done because to enable ASPM for some cards
you often need to tune the host controller in addition to enabling
ASPM for the endpoint, so this will vary depending on vendor, chipset,
and host controller combination. This is documentation that the OEM /
ODM typically end up getting, but not end users.

So given the complexity its best to be selective about it on each
platform until you verify ASPM works well for all devices present.

  Luis
