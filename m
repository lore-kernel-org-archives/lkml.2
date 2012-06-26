Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab2FZKch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 06:32:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65394 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2FZKcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 06:32:36 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20120626095247.GK30406@opensource.wolfsonmicro.com>
References: <1340697707.12992.1.camel@phoenix> <20120626090825.GI30406@opensource.wolfsonmicro.com>
 <CAF+7xWnJo3VrZ+iH4BJHkTmo5+D9ttZ1n1Tm0KMPQqK1sKD7wQ@mail.gmail.com> <20120626095247.GK30406@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 26 Jun 2012 18:32:15 +0800
Message-ID: <CAF+7xWmt-K0s0sE1D6db5JNSApeKS5p_=rDkR_-j8+g6V+C2Og@mail.gmail.com>
Subject: Re: [PATCH] regulator: arizona-micsupp: Fix choosing selector in arizona_micsupp_map_voltage
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Tue, Jun 26, 2012 at 05:27:26PM +0800, Axel Lin wrote:
>
> Your mailer is doing something *really* odd with word wrapping, please
> fix it.  It looks like it's just randomly wrapping lines rather than
> flowing paragraphs.
I've no idea why gmail do the odd word wrapping...

>
>> 2012/6/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > This is OK but I think we want to factor this out into the caller as
>> > we're implementing this limits check in a lot of places.
>
>> It seems most of the new code are calling list_voltage() in
>> map_voltage to ensure
>> the selected voltage are still in bound.
>> for this case looks wrong to me.
>> But in this  case, current actually set selector to
>> ARIZONA_MICSUPP_MAX_SELECTOR in map_voltage() if
>> min_uV >= 3300000. calling list_voltage() still returns valid voltage
>
> Which we then immediately check against min_uV so as far as I can tell
> we're fine here even with no code modifications.
>
>> If min_uV is in the range of: 3250001~3269999,
>> current code uses the equation: selector = DIV_ROUND_UP(min_uV -
>> 1700000, 50000);
>> Then selector will be 32.
>> Then arizona_micsupp_list_voltage returns -EINVAL for this case.
>
> OK, please submit a separate change for this.  It would sometimes help
> if your changelog entries were clearer, while you do normally provide a
> lot of detail but you often don't highlight which are the important
> details or miss critical ones about why your change is important.  Your
> original changelog for this makes it look like this is just a change
> being made for taste reasons since it doesn't mention the error case.
I will send the patch with better changelog.

Regards,
Axel
