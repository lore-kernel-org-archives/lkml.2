Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0GZW1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:27:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56139 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab0GZW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=u1b/IxT+Af9VFkUOUVhLw5DGnXbLjbjzzkrI04ye8UKWZKTnk4/sgqJImzVkal0y9z
         jZTpouiMjfprM0o9C4j6YCoIgz9QYxdRzwpLJI/g2q52VPMcZs4XRK7KKcSfT5cf1OF/
         5WGC82mPEYBKCyH+YvRmAVwI/thxJfVNOGKK8=
MIME-Version: 1.0
In-Reply-To: <20100726222113.GA6487@srcf.ucam.org>
References: <1276933774.16697.11.camel@maxim-laptop> <20100619123841.GA31838@hash.localnet> 
	<1276952554.3332.3.camel@maxim-laptop> <1276961564.5173.12.camel@maxim-laptop> 
	<20100726201322.GI14855@tux> <1280177362.3721.7.camel@maxim-laptop> 
	<20100726210651.GJ14855@tux> <1280179033.3721.15.camel@maxim-laptop> 
	<20100726212543.GA5424@srcf.ucam.org> <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com> 
	<20100726222113.GA6487@srcf.ucam.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 15:26:37 -0700
Message-ID: <AANLkTinq-SxMHTrJM23WaeRMkU-2cySiVrkwCjDRS_o+@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        "ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        David Quan <David.Quan@atheros.com>,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 3:21 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Jul 26, 2010 at 03:15:32PM -0700, Luis R. Rodriguez wrote:
>> On Mon, Jul 26, 2010 at 2:25 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> > This may need to be done on a chip by chip basis. Take a look at
>> > http://www.atheros.cz/inffile.php?inf=68&bit=32&atheros=AR5002G&system=4
>> > and some of the other inf files on that site to see which devices
>> > provide the PciASPMOptIn flag - those should support ASPM states even if
>> > they're pre-1.1 devices.
>>
>> I rather we not bother with these, lets simply follow the kernel's
>> lead here for its rule matching.
>
> Sorry? The idea is to indicate which chips support ASPM even though
> they're pre-PCIe 1.1. If all Atheros parts work fine with L1 then that
> makes things much easier, but it would be good to know the correct set
> of chips that are broken with L0s.

What I meant was that the PCI config space would already have L1
enabled if L1 worked, so I don't see why we would need to nitpick out
specifics here. All Atheros PCIE chips should work with L1. The advise
given is to disable L0s though. I believe AR2425 would be one which
likely had L0s enabled but requires it to be disabled. Not sure of
others. But this is why I am saying this can be done globally for all
ath5k chipsets.

  Luis
