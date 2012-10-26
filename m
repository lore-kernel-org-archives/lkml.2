Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab2JZER0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:17:26 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62314 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2JZERZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:17:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpom5QmO5vbREsMgi4EefLpBxXsk=QWVaZwTwC_Knf72GVA@mail.gmail.com>
References: <425b4bec021bce9a2de49959121907aeede6a0b9.1350064805.git.viresh.kumar@linaro.org>
	<CAKohpom42SCMJ+=TdvAjqT0ibRugJi_gXkLy+49N6ExcRZqxLQ@mail.gmail.com>
	<50893C45.7010109@gmail.com>
	<CAKohpom5QmO5vbREsMgi4EefLpBxXsk=QWVaZwTwC_Knf72GVA@mail.gmail.com>
Date: Fri, 26 Oct 2012 09:47:24 +0530
Message-ID: <CAKohponSbbusMjcsEwKczvxaN54YKJPL05vLELSjW6dnKO_6Dg@mail.gmail.com>
Subject: Re: [PATCH] dt: add helper function to read u8 & u16 variables & arrays
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: grant.likely@secretlab.ca, spear-devel@list.st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 19:48, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> The problem i see here is:
>
> The data passed via DT comes as Little Endian in the kernel.
>
> For a little endian system, byte zero will contain the data and so
> (u8) val
>
> look to be the correct thing.
>
> For a big endian system, byte 3 will contain data as it is swapped by
> be32_to_cpup.
> So (u8) val would return value stored by byte 0 instead. ??

I feel above explanation was wrong. I didn't had a big endian system
to test this but this is what i derived theoretically. Consider following
sequence of commands:

u32 x = 0x01;              //This will store off-0: 1, off-3:0 for LE system
                                   // and will store off-0: 0, off-3:1
for BE system
u8 y = (u8) x;              // For any architecture type, i.e. big or
little this must store
                                   // 1 in y. This is ANCI C semantic
and should be architecture
                                   // independent.

Which would mean, type cast will give off-0 on LE and off-3 on BE systems. Don't
confuse this with getting values using pointers, as we try to get data
out of specific
locations in those cases.

So, my initial code seems to be doing the right thing. be32_to_cpup()
will move the
LSB to off-3 and that is what we will get during the cast.

I will resend my original code to you.

--
viresh
