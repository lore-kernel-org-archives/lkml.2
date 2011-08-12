Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1HLWR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:17:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53345 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1HLWR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110812220316.GA28845@merkur.ravnborg.org>
References: <4E457682.5020107@codeaurora.org>
	<1313175602-21834-1-git-send-email-sboyd@codeaurora.org>
	<CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com>
	<20110812205520.GL4775@n2100.arm.linux.org.uk>
	<CACqU3MX=-10ouxCqWcBP7MW3_O4_RSLG9wRY8X4iEh5ydQa1AQ@mail.gmail.com>
	<20110812220316.GA28845@merkur.ravnborg.org>
Date: Fri, 12 Aug 2011 18:17:25 -0400
Message-ID: <CACqU3MUVir_hfAtVz24Y7NrQOHAa=WyyHnCN4M6BHLQ294Tdww@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 12, 2011 at 6:03 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> I suspect this would have done the job:
>>
>> $(obj)/font.o: $(srctree)/drivers/video/console/font_acorn_8x8.c
>>         $(cmd,cc_o_c)'
>
> I prefer using $(call,shipped) and let kbuild figure out how
> build an .o file from a .c file.
>
> In other words - avoiding use of the internal to Makefile.build
> variables in various places.
>
indeed, but I'd argue that 1) this would not be the first Makefile
using these internal macros (alpha and ia64 are using such construct
for aliasing) and 2) the `cmd_shipped' stuff is as internal than other
functions :-)

I wonder if we could not make kbuild provide an interface for such code-reuse...

 - Arnaud
