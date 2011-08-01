Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1HAPPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 11:15:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58106 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1HAPPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 11:15:45 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MVUxTYmD+4VGBAeN8PTs83fR0xQQrQS5h4QGMZXgMxEvA@mail.gmail.com>
References: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
 <20110801083614.GC15578@n2100.arm.linux.org.uk> <CAMuHMdUpTDSRP_JmWqcCBtYwzna0hwmaBshpiF8kgvqoNcqYZA@mail.gmail.com>
 <20110801101410.GE15578@n2100.arm.linux.org.uk> <CAMuHMdUiLjMVwOqKPF6tHLpPxROrx=rRf3ednfTLrwGuZ2VF7A@mail.gmail.com>
 <CACqU3MVUxTYmD+4VGBAeN8PTs83fR0xQQrQS5h4QGMZXgMxEvA@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 1 Aug 2011 11:15:24 -0400
Message-ID: <CAGZ=bqL=VAx5jnSBkE2q5KJSY_+An-VRTRAzJmJ3waQUvrRFFg@mail.gmail.com>
Subject: Re: [PATCH] Remove remaining references of CONFIG_GENERIC_TIME
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Zoltan Devai <zdevai@gmail.com>, linux-kernel@vger.kernel.org,
        chris@zankel.net, linux-am33-list@redhat.com, trivial@kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, cmetcalf@tilera.com,
        linux-arm-kernel@lists.infradead.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 11:04, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Mon, Aug 1, 2011 at 7:27 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Mon, Aug 1, 2011 at 12:14, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>>> On Mon, Aug 01, 2011 at 12:09:02PM +0200, Geert Uytterhoeven wrote:
>>>> On Mon, Aug 1, 2011 at 10:36, Russell King - ARM Linux
>>>> <linux@arm.linux.org.uk> wrote:
>>>> > On Sat, Jul 30, 2011 at 06:14:38PM +0200, Zoltan Devai wrote:
>>>> >> Commit 592913ecb87a9e06f98ddb55b298f1a66bf94c6b has killed off any
>>>> >> use of this config option long ago.
>>>> >
>>>> > I don't see the point of this - we were free of GENERIC_TIME on ARM
>>>> > shortly after it was originally killed off.  The problem is you can't
>>>> > stop people introducing new uses of this - because it existed once and
>>>> > there's nothing which errors out on its presence, people are going to
>>>> > continue submitting patches with it in.  And it's going to continue
>>>> > being missed at the review stage.
>>>> >
>>>> > I've a similar problem with folk on ARM including mach/gpio.h as their
>>>> > sole gpio header file rather than linux/gpio.h - I've been trying for
>>>> > the last 1-2 years to educate people to use linux/ in preference.  You
>>>> > can't do it, and I'm still just about the only one who picks up on that.
>>>> > (SoC maintainers don't care.)  They will end up caring when I push a
>>>> > change during the next merge window though, so I'll eventually stop
>>>> > mach/gpio.h being included.  (Instead, it'll be asm/gpio.h).
>>>> >
>>>> > GENERIC_TIME though... I don't think you'll ever stop new uses of it
>>>> > creeping in unless you can arrange for something to error out.
>>>>
>>>> Doesn't kconf error out when trying to select a non-existent symbol?
>>>
>>> Nope.
>>
>> You're right. So that's a bug.
>>
> depends on what you are trying to achieve and what the problem is.
>
> Internally kconfig will create a dummy symbol when it encounter a
> missing symbol so that arch/arm/Kconfig can reference a symbol which
> will be fully defined later on. I do not think you want to forward
> decl all the symbol which can be used. That'd be a mess. That said, we
> can come with a form of symbol deprecation that would error-out when
> used.

Would it be possible instead to make Kconfig go through all the symbols
after everything is processed and identify any remaining "dummy symbols"
which were not actually declared anywhere?

Right now if you typo a "select" statement you get no warnings that you
are selecting something that does not exist, which is probably a cause
of many kinds of errors beyond this particular one.

Cheers,
Kyle Moffett
