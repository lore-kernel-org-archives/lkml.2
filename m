Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab2HTOSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:18:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57757 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2HTOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:18:16 -0400
MIME-Version: 1.0
In-Reply-To: <CABJ1b_TCF=Jfb0uuoh-M87n6faezj4OqZ4S_nJLA0yKga2-ioQ@mail.gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkda0wUW4E3y=ucGRFu5fwwyFWo2dc=4qBaH6CFSOW2ZL_A@mail.gmail.com>
	<CABJ1b_TCF=Jfb0uuoh-M87n6faezj4OqZ4S_nJLA0yKga2-ioQ@mail.gmail.com>
Date: Mon, 20 Aug 2012 16:18:15 +0200
Message-ID: <CACRpkdaozBQPe1PkjaKrnqYZ=tpX1mv1iS-rCrJaSFAsQqzgnA@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: mvebu: pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 11:46 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> On 8/20/12, Linus Walleij <linus.walleij@linaro.org> wrote:

>> Are you taking this patch series through some Marvell tree or do you want
>> me to carry it in the pinctrl tree?
>
> I think it would be better to take it through the Marvell tree of Jason
> Cooper. It is only for Marvell SoCs anyway.

OK.

>> There is some other "variant" field elsewhere that is
>> a u8, is this correct? In this and the other case, should
>> this "variant" rather be an enum?
>
> I'll review the variant types but inside pinctrl-mvebu variant
> is used as a bit mask to distinguish different variants. Anyway,
> they should always be the same size.

Aha bitmask, seems you can only have 8 different variants of
the Marvell's then?

>> Is it possible to use devm_* managed devm_kzalloc() for this map
>> so you don't need to free it explicitly?
>>
>> (Maybe not, just checking.)
>
> Hmm, I guess not as I thought I've read not to use devm_kfree when
> you allocate _and_ free stuff on runtime without removing the device
> itself, right?

You're right.

>> So, there will never be > 256 pins on a Marvell platform?
>
> Well, with all current platforms we are well below 100. I guess
> 256 max (muxable) pins will be enough.

OK.

>>> + * struct mvebu_mpp_ctrl_setting - describe a mpp ctrl setting
>>> + * @val: ctrl setting value
>>
>> It is not obvious to me what this means, it it possible to elaborate
>> on how this member is defined and used?
>
> Well, I see if I can clarify the description but wrt the datasheet it
> _should_ be quite obvious.

I mainly worry about being able to read the code and figure out
what's going on, if the datasheet is vital then pls include some
link to it or so in the header of the file (but preferrably the code
should speak for itself).

>>> + * @variant: (optional) variant identifier mask
>>
>> This thing again, there are lots of "variants" around here.
>> Is it a candidate for an enum?
>
> As it is a mask, I don't think enum fits here.

OK. No big deal anyway.

> In some internal review with Andrew I also added a spinlock to
> mvebu_pinconf_get/_set that will protect all calls to generic and specific
> _get/_set register accesses. Moreover, I replaced clk_get_sys in pinctrl-dove
> with the devm_ counterpart and removed the explicit clk_put.

I had some separate comments on that clk thing...
Anyway, looking forward to v2, this is progressing quickly
I think.

Yours,
Linus Walleij
