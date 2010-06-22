Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0FVTiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:38:25 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:63658 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0FVTiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Tx4GIFqexLOwf5A98k2qp6qF5Ri4EeqheOEcSouI+xHDMB6tK1Nwz7m5eet+dKZdTK
         htXIZsn5iI745TcSfiHYxrMmHozRRcUaiYlzSsCqrZQR55Tnwwkv3PyibSu+NO4hgRdl
         Ns6ddff14RDFS4OlS5jGFeyRl2n6Z2aaS4mGQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTin1fAAgYTYegqaadkYIYP2NXRNRzCR48e-uIgYV@mail.gmail.com>
References: <AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> 
	<20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com> 
	<20100622165213.GA21842@srcf.ucam.org> <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com> 
	<20100622172545.GA22680@srcf.ucam.org> <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com> 
	<20100622175058.GA23499@srcf.ucam.org> <AANLkTinE0BiOa5cpcIerbias7K-aDzj3x4qaeDpzy2CQ@mail.gmail.com> 
	<20100622184426.GA24546@srcf.ucam.org> <20100622193143.GA17803@sig21.net> 
	<AANLkTin1fAAgYTYegqaadkYIYP2NXRNRzCR48e-uIgYV@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 22 Jun 2010 12:38:03 -0700
Message-ID: <AANLkTimsEkff4sMiMB_VyWqkZOjy9PIuJ4AiC95PASOZ@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Johannes Stezenbach <js@sig21.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>,
       Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 12:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jun 22, 2010 at 12:31 PM, Johannes Stezenbach <js@sig21.net> wrote:
>> On Tue, Jun 22, 2010 at 07:44:26PM +0100, Matthew Garrett wrote:
>>> On Tue, Jun 22, 2010 at 11:28:20AM -0700, Luis R. Rodriguez wrote:
>>> >
>>> > Heh, this whole patch and thread was started because Jussi tested
>>> > ath5k with  pcie_aspm=force (on a pre PCIE 1.1 device (?)) . I have
>>> > been trying to explain all along why this is a terrible idea to the
>>> > point we should probably just remove that code from the kernel. Hence
>>> > my side rants and explanations to justify my reasonings.
>>>
>>> Well, there's two things here. If you use force then you might get
>>> inappropriate ASPM. But if your BIOS enables ASPM on an old device, then
>>> booting *without* CONFIG_PCIE_ASPM will leave it turned on, and booting
>>> *with* CONFIG_PCIE_ASPM will turn it off. The Kconfig description is
>>> confusing - reality is that CONFIG_PCIE_ASPM enables logic that allows
>>> the kernel to modify the BIOS default, and disabling it makes the
>>> assumption that your BIOS did something sensible.
>>
>> Does CONFIG_PCIEASPM provide a way for the user to modifiy
>> the settings at runtime?
>
> You can tune ASPM settings at runtime, regardless of CONFIG_PCIEASPM. See:
>
> http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm
> http://wireless.kernel.org/en/users/Documentation/ASPM
>
>> I have a Samsung N130 netbook which has a BIOS setting
>> called "CPU Power Saving Mode".  When enabled it activates
>> ASPM L1 and L0s for the ethernet chip (Realtek RTL8102e, 100Mbit)
>> and the PCIE bridge (with the BIOS setting off it's just L1).
>> The result is that the ethernet througput is reduced to 25Mbit/s.
>> (The BIOS setting does not activa L0s for the Atheros AR9285 WLAN.)
>>
>> 99,9% of the time I want to enjoy the power savings,
>> but occationally I have to transfer some bulk data and would
>> like to switch the setting for a few minutes.
>>
>> Or, well, ideally I'd like to have power savings _and_ performance
>> at the same time without any manual intervention.  I'm not sure
>> if this is a quirk of the N130 or if ASPM L0s always causes
>> performance degradation?
>
> L0s is not going to buy you much gains, getting at least L1 will
> however. L0s is just a further enhancement. I recommend you test by
> enabling L1 and L0s, check how longer your battery lasts and then test
> again with just L1. Then test without both L1 and L0s.

So defaults should always be sane and you should not have to play with
this stuff, unless you're a hacker, or are testing something for
development purposes. Tweaking ASPM settings is not something a user
should have to worry about. Period.

  Luis
