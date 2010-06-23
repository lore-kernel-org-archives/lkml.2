Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0FWQfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:35:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57570 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0FWQf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PMPBMcCx+yMhz8EvJ0n1BXdJoPxWoLQEq/dwaTlJ7giSW8F49lI6lUI+IHAds7Xgz8
         xvHd5HnCCJzuvvQZCbiZTniLLK/2DLxBasR3phaPRRcf99XRl220EVjdwoKafn5VTlOc
         Tj+C99o3Pa2nF/73Jc2eJ46AdEmlba1zFum1c=
MIME-Version: 1.0
In-Reply-To: <20100623143940.GA5424@sig21.net>
References: <20100622165213.GA21842@srcf.ucam.org> <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com> 
	<20100622172545.GA22680@srcf.ucam.org> <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com> 
	<20100622175058.GA23499@srcf.ucam.org> <AANLkTinE0BiOa5cpcIerbias7K-aDzj3x4qaeDpzy2CQ@mail.gmail.com> 
	<20100622184426.GA24546@srcf.ucam.org> <20100622193143.GA17803@sig21.net> 
	<AANLkTin1fAAgYTYegqaadkYIYP2NXRNRzCR48e-uIgYV@mail.gmail.com> 
	<AANLkTimsEkff4sMiMB_VyWqkZOjy9PIuJ4AiC95PASOZ@mail.gmail.com> 
	<20100623143940.GA5424@sig21.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 23 Jun 2010 09:28:57 -0700
Message-ID: <AANLkTilyQB-q8Xf9Mu3F5SnKbRqbBuLjbdx8EcyCt_0v@mail.gmail.com>
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

On Wed, Jun 23, 2010 at 7:39 AM, Johannes Stezenbach <js@sig21.net> wrote:
> On Tue, Jun 22, 2010 at 12:38:03PM -0700, Luis R. Rodriguez wrote:
>> On Tue, Jun 22, 2010 at 12:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > On Tue, Jun 22, 2010 at 12:31 PM, Johannes Stezenbach <js@sig21.net> wrote:
>> >>
>> >> Does CONFIG_PCIEASPM provide a way for the user to modifiy
>> >> the settings at runtime?
>> >
>> > You can tune ASPM settings at runtime, regardless of CONFIG_PCIEASPM. See:
>> >
>> > http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm
>> > http://wireless.kernel.org/en/users/Documentation/ASPM
>> >
>> >> I have a Samsung N130 netbook which has a BIOS setting
>> >> called "CPU Power Saving Mode".  When enabled it activates
>> >> ASPM L1 and L0s for the ethernet chip (Realtek RTL8102e, 100Mbit)
>> >> and the PCIE bridge (with the BIOS setting off it's just L1).
>> >> The result is that the ethernet througput is reduced to 25Mbit/s.
>> >
>> > L0s is not going to buy you much gains, getting at least L1 will
>> > however. L0s is just a further enhancement. I recommend you test by
>> > enabling L1 and L0s, check how longer your battery lasts and then test
>> > again with just L1. Then test without both L1 and L0s.
>>
>> So defaults should always be sane and you should not have to play with
>> this stuff, unless you're a hacker, or are testing something for
>> development purposes. Tweaking ASPM settings is not something a user
>> should have to worry about. Period.
>
> OK, let me put the question another way:
>
> If enabling ASPM comes with a performance penalty (which is not unexpected,
> there is usually a tradeoff between performance and power consumption),
> do you think a boot time option (pcie_aspm=) or compile time option
> (CONFIG_PCIEASPM) is the right user interface?
>
>
> But meanwhile I found that CONFIG_PCIEASPM has a runtime
> interface, /sys/module/pcie_aspm/parameters/policy.
> http://lwn.net/Articles/266585/
>
> I have not tested it on my N130 yet.

Same thing, its to be used by developers not users, damn it we should
just remove this crap.

  Luis
