Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2KQKNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 05:13:12 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64446 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2KQKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 05:13:09 -0500
MIME-Version: 1.0
In-Reply-To: <20121116122540.GA2198@lizard>
References: <1353047903-14363-1-git-send-email-acourbot@nvidia.com>
 <1353047903-14363-2-git-send-email-acourbot@nvidia.com> <20121116072642.GA22291@lizard>
 <50A60AF6.9080509@nvidia.com> <20121116122540.GA2198@lizard>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Sat, 17 Nov 2012 19:12:45 +0900
X-Google-Sender-Auth: nPdZIc65oSw0mn8rEE4JEDsXJUo
Message-ID: <CAAVeFuJ28=YFOx1Uvq+B33JQW2UxDYx2J8igUnVCbTEO0V-KKg@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] Runtime Interpreted Power Sequences
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 9:25 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>> The POWER_SEQ_*_TYPE macros are defined in the C files. It's the
>> simplest way to initialize this table, and the code inside these C
>> files is short and simple enough that I thought I would be forgiven.
>> :)
>
> I think in the header file you could just write
>
> extern ..... power_seq_delay_type;
> #ifndef ...
> #define power_seq_delay_type NULL
> #endif
>
> And then, in the .c file:
>
> static const struct power_seq_res_ops power_seq_ops[POWER_SEQ_NUM_TYPES] = {
>         [POWER_SEQ_DELAY] = power_seq_delay_type,
>         ...
> };
>
> And then you can stop including the .c files directly, and link them
> instead.

I have done something similar, but that avoids exporting resource ops
into the header file. I am still not satisfied with it though - I'd
rather have one init function per resource file that changes the
pointer of the ops table from NULL to its own set of functions. That
way the core could live without knowing anything about the different
resources, and that would be nicer. Unfortunately modules only support
one init function, so this is not doable here.

>> >nit: one variable declaration per line.
>>
>> Fair enough - but is that a convention? checkpatch.pl was happy with these.
>
> It's not a rule, although there is a small passage about it in CodingStyle
> file when it describes commenting style. Though, some folks choose to
> ignore this suggestion quite frequently, especially if variables have no
> comments.
>
> Often, the multiple declarations per line are used to hide ugly functions
> w/ tons of variables, or just to confuse the reader for the fun of it.
>
> There are exceptions, of course. E.g.
>
>         int i, j, k; /* Our iterators. */
>
> Is perfectly fine.
>
> But
>         int i, err;
>
> At least to me seems weird, this stuff is logically disjunct.
>
> Only human can truly differentiate when the stuff "looks better" together
> or apart, so that's why checkpatch doesn't complain. Personally, I use
> this rule of thumb: when in doubt, use just one declaration per line, it
> is always OK. :)

That totally makes sense - thanks for the precision.

Prepping another patchset with audience extended to linux-arm-kernel
as Mark suggested.

Alex.
