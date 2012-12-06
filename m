Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423082Ab2LFKUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 05:20:54 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63247 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423069Ab2LFKUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 05:20:51 -0500
X-Greylist: delayed 1487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 05:20:51 EST
MIME-Version: 1.0
In-Reply-To: <20121206095019.GN2718@gmail.com>
References: <2dcd7cb4c4022fa24b5328974e4226f5aaf89419.1354199865.git.viresh.kumar@linaro.org>
	<121653def4e985b0c1b59045637dd4518f97e73a.1354199865.git.viresh.kumar@linaro.org>
	<20121130105731.GN3176@sortiz-mobl>
	<20121130154542.GG23648@gmail.com>
	<CAKohpokLVEH+4F_VXh5auUm48cWWe0mumZME8yOCcAezcwJbCQ@mail.gmail.com>
	<20121205224203.691153E0E22@localhost>
	<CAKohponjLp214EPKgNHqP2N8Tje9U8ZxgywUTSvsjE-TqHy+xw@mail.gmail.com>
	<20121206095019.GN2718@gmail.com>
Date: Thu, 6 Dec 2012 15:26:02 +0530
Message-ID: <CAKohpokNQB6L2vvjmvA7_3KomFXnV9wZ-uBjrfRVuBL=QWgr_Q@mail.gmail.com>
Subject: Re: [PATCH V5 2/2] mfd: stmpe: Update DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, rabin.vincent@stericsson.com,
        shiraz.hashim@st.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linus.walleij@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 December 2012 15:20, Lee Jones <lee.jones@linaro.org> wrote:
>> > But regardless, it is the responsiblity of the probe function to go and
>> > look if of_driver_match_device() matches against anything if it cares
>> > about the of_match_table entries (for instance, if there is extra data
>> > attached).
>>
>> Ok, so filling .data field in of_device_id[] is not required for our case as
>> we aren't doing anything special in our drivers.
>
> This is exactly my point, and the reason I bought it up in the
> first place. Normally when you specify an ID table and populate
> the .data attribute, you parse for it in the code and then cast
> it back to some kind of useful data. However, you're not doing
> that, which is precisely why I wondered if the table was
> necessary at all. In all my testing, the DT portion worked and
> the correct STMPE chip was identified without it.

Probably Vipul (Author of this patch), copied it from existing i2c/spi
clients, which have also added this blindly :)

> So, are you adding the table for good reason, or because you
> think it's the right thing to do?

I would be keeping the table as that's the right thing to do. By chance
our non-DT and DT tables had a difference of "st," only in the name
of instances and so it worked without tables. Otherwise it couldn't
have worked.

Over that, i am looking to bring the "stmpe,id" binding back again (unless
you have a better option), as device name is not coming from DT currently,
which we discussed earlier.

--
viresh
