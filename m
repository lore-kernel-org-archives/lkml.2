Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1CAQem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 11:34:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:15368 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1CAQel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 11:34:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NG4cLOVJscAP0B8eLmmD5qWe6nfiqP1trFXz/cTXXdT3qUz1vg6llG/Gj0whljageF
         Lu4F6GdJTyxLfEYDKzCA==
MIME-Version: 1.0
In-Reply-To: <20110301100306.GA18007@n2100.arm.linux.org.uk>
References: <1298939263-16421-1-git-send-email-sjg@chromium.org>
	<20110301084949.GA16733@n2100.arm.linux.org.uk>
	<20110301085911.GB16733@n2100.arm.linux.org.uk>
	<19820.47240.801312.507393@pilspetsen.it.uu.se>
	<20110301100306.GA18007@n2100.arm.linux.org.uk>
Date: Tue, 1 Mar 2011 08:34:37 -0800
X-Google-Sender-Auth: -OWrbqcrPkKAQpL90LGpXTH14YY
Message-ID: <AANLkTinMnZAupxn7oYFhqkN1Y0OD-eyN=UeRpw96no9r@mail.gmail.com>
Subject: Re: [RFC PATCH] ARM: Use generic BUG() handler
From: Simon Glass <sjg@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Alexander Shishkin <virtuoso@slind.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 2:03 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Mar 01, 2011 at 10:12:40AM +0100, Mikael Pettersson wrote:
>> Russell King - ARM Linux writes:
>>  > On Tue, Mar 01, 2011 at 08:49:49AM +0000, Russell King - ARM Linux wrote:
>>  > > On Mon, Feb 28, 2011 at 04:27:43PM -0800, Simon Glass wrote:
>>  > > > +      asm volatile("1:\t.word %c3\n"                          \
>>  > > > +                   ".pushsection __bug_table,\"a\"\n"         \
>>  > > > +                   "2:\t.word 1b, %c0\n"                      \
>>  > > > +                   "\t.hword %c1, 0\n"                        \
>>  > > > +                   "\t.org 2b+%c2\n"                          \
>>  > >
>>  > > %c doesn't work on lots of versions of gcc, which is why we can't use
>>  > > the generic bug support.  There's no way to reliably generate constants
>>  > > without many compiler versions spitting out a '#' before them.
>>  >
>>  > gcc 4.3.2:
>>  >
>>  > asm(".word %c0" : : "i" (0));
>>  >
>>  > produces:
>>  >
>>  >         .word #0
>>  >
>>  > which gas chokes on:
>>  >
>>  > /tmp/cc2hGOHd.s:12: Error: bad expression
>>  > /tmp/cc2hGOHd.s:12: Error: junk at end of line, first unrecognized character is `0'
>>  >
>>  > So what this means is that it's impossible to generate constants in
>>  > assembly with GCC targetting ARM without having them prefixed by '#',
>>  > which in turn makes it impossible to use the generic BUG support.
>>  >
>>  > I reported this bug to gcc folk many years ago.  I've no idea which
>>  > version it has been fixed in or if it's even been fixed.
>>
>> What's the gcc bugzilla bug number?
>
> No idea off hand - I'll have to search for that.
>

It seems I am lucky with the gcc I am using. I would have thought this
would be a pretty fundamental feature, but yes I did notice that %c
wasn't used anywhere.

Would this kernel feature be acceptable as a selectable config option
on ARM then?

Thanks,
Simon
