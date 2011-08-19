Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1HSSpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:45:15 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:55297 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1HSSpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:45:13 -0400
MIME-Version: 1.0
In-Reply-To: <1313774883.18591.11.camel@vkoul-udesk3>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	<1313499399.1603.92.camel@vkoul-udesk3>
	<CACRpkdaY_wuz+zS-iKCPT-M7EpvtxCNX+OJ6NROSaQtZ6XoNMg@mail.gmail.com>
	<1313761404.18591.1.camel@vkoul-udesk3>
	<CAKnu2Mpu2H18=xF4OwmqSgML_dDa6SE7ZqHFjLb2GL_-Wabqsw@mail.gmail.com>
	<CAJe_ZhfSsE40ucx5=f7bBJ5WXeWib=OdGRyFTA-3Di6i608EOw@mail.gmail.com>
	<1313774883.18591.11.camel@vkoul-udesk3>
Date: Sat, 20 Aug 2011 00:15:10 +0530
Message-ID: <CAJe_ZhcD4skw18H-nM6+jkkBnQ0ppNHaJnDSf+cC+Fwb1_mLjQ@mail.gmail.com>
Subject: Re: [PATCH] DMAEngine: Define generic transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        "sundaram@ti.com" <sundaram@ti.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "nsekhar@ti.com" <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2011 22:58, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Fri, 2011-08-19 at 21:16 +0530, Jassi Brar wrote:
>> On 19 August 2011 19:49, Linus Walleij <linus.ml.walleij@gmail.com> wrote:
>> > 2011/8/19 Koul, Vinod <vinod.koul@intel.com>:
>> >> On Tue, 2011-08-16 at 15:06 +0200, Linus Walleij wrote:
>> >>> On Tue, Aug 16, 2011 at 2:56 PM, Koul, Vinod <vinod.koul@intel.com> wrote:
>> >
>> >>> I think Sundaram is in the position of doing some heavy work on
>> >>> using one or the other of the API:s, and I think he is better
>> >>> suited than anyone else of us to select what scheme to use,
>> >>> in the end he's going to write the first code using the API.
>> >
>> >> And Unfortunately TI folks don't seem to care about this discussion :(
>> >> Haven't seen anything on this from them, or on previous RFC by Jassi
>> >
>> > Well if there is no code usig the API then there is no rush
>> > in merging it either I guess. Whenever someone (TI or
>> > Samsung) cook some driver patches they can choose their
>> > approach.
>> >
>> No, it's not a matter of "choice".
>> If that were the case, Sundaram already proposed a TI specific
>> flag. Why wait for him to tell his choice again?
>>
>> You might, but I can't molest my sensibility to believe that a Vendor
>> specific flag could be better than a generic solution.
>> Not here at least, where the overhead due to generality is not much.
>> (though I can trim some 'futuristic' members from the 'struct xfer_template')
> Who said anything about adding a vendor flag solution,
Not you, but to whom I replied - LinusW   See https://lkml.org/lkml/2011/7/11/74

> since TI are potential users of the API it would good to know i this fits there needs
> are not.
I am super-interested to hear from TI guys.
The generic api here rather supports the case Sundaram projected as
'most' general case. Look at the figure at end of
https://lkml.org/lkml/2011/6/9/343

>> Maintainers might wait as long as they want, but there should never
>> be an option to have vendor specific hacks.
> to me API looks decent after reading some specs of DMACs which support
> this mode. Pls send updated patch along with one driver which uses it.
> Should be good to go...
That has been one problem with DMAEngine. People patch the API as they need
stuff, rather than having had solid thought-out API that could be
extended consistently.
For ex, we ended up having _ten_ device_prep_dma_* callbacks, where as
we could have done having had originally 1 (or maybe 2)  'generic'
prepare callback with a 'enum dma_transaction_type op' argument.
IMO it's rather good that I designed this API for a theoretical
highly-capable DMAC,
and not just the DMAC I've worked on - which would have constrained
the api in future
for other DMACs.
