Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2IXPse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:48:34 -0400
Received: from science.horizon.com ([71.41.210.146]:60184 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756029Ab2IXPsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:48:33 -0400
Date: 24 Sep 2012 11:48:32 -0400
Message-ID: <20120924154832.12150.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: geert@linux-m68k.org, linux@horizon.com
Subject: Re: [PATCH 2/4] lib: vsprintf: Optimize division by 10000
Cc: hughd@google.com, linux-kernel@vger.kernel.org, mpn@google.com,
        vda.linux@googlemail.com
In-Reply-To: <CAMuHMdUt3WvLgt73L39BZ4D5_qDr7ZCYhTz6RDEsH4qV2vSa7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Mon, Sep 24, 2012 at 3:56 PM, George Spelvin <linux@horizon.com> wrote:
>> SPARCv8 UMUL puts the high half of the 64-bit result into the Y
>> register, and SPARCv7 has a multiply-step instruction (MULScc) which
>> does likewise.
>
> Early SPARCs don't even have a multiply instruction.

Are you sure we're not talking about the same thing?  Early SPARCs didn't
have a *single* multiply instruction, but *did* have a multiply step
instruction, which can be iterated to produce a 32x32->64-bit multiply.

That's what I was referring to.  All multiplies were slow, but widening
multiply was no slower.

And SPARCv7 had no divide support at all, so that was *really* slow.

SPARClite added a divide step, but also added an integer multiply
instruction, so again widening multiply beat the pants off divide.
