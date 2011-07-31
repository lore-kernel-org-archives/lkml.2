Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1GaWIC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:08:02 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58571 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1GaWH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <1312143643.12369.32.camel@i7.infradead.org>
References: <1312141497-13854-1-git-send-email-lacombar@gmail.com>
	<1312143643.12369.32.camel@i7.infradead.org>
Date: Sun, 31 Jul 2011 18:07:55 -0400
Message-ID: <CACqU3MXak0Yo+VDQNEqT9rTJ5CjdU6jJ-C1Km7GauMQ+qGW+vg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: honor the ARCH setting of the existing configuration
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 4:20 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sun, 2011-07-31 at 15:44 -0400, Aunt Tillie wrote:
>> This change make Kbuild honor the ARCH setting of the existing configuration, if
>> any .config is present so that it does not get reset if there is a conflict
>> with the default ARCH for the platform and the current setting.
>
> I think this is the wrong approach.
>
> There are plans to make the architecture a *real* configuration option,
> and that will be lovely when it happens (and changing the 32-vs-64
> distinction so that it's no longer a different ARCH but just a config
> option is one step in that direction).
>
> But I don't think this patch is really a helpful step towards that goal;
> we should do that *properly* or not at all, and not give some temporary
> half-baked behaviour in the meantime, that people will come to depend on
> (and others will hate because it means they can't just take an ARM
> config and build it on their x86 box and have it automatically
> converted).
>
Irrelevant. This can still be done explicitly:

% make ARCH=arm defconfig
[... time passes ...]
% make ARCH=i386 oldconfig

> And the other problem is that this is not really addressing the
> underlying issue, which is that we are still clinging to the legacy ARCH
> values for directories which don't exist in the arch/ directory any
> more, and which are *redundant* with the setting of CONFIG_64BIT in the
> config.
>
no. The relation between the target architecture and bitness' width is
not a bijection, and treating it as such is short-sighted.

> The only problem here is that we're not using the merged ARCH=x86 by
> default, as most of the other 64-bit capable architectures in the kernel
> do — and it works just fine for all of them.
>
> If the x86 merge still hasn't been completed, four years after we
> deleted arch/{i386,x86_64}, then we need to complete it. Thanks for
> helping to root out the few esoteric things that still don't quite work
> right on x86; it's very useful to find them and fix them.
>
I think you totally miss the point of the patch as you keep being
self-centered on x86.

I am working with configuration for mips, sh, powerpc, arm and x86.
Some of them are for real board, some of them are to regress-test
compilers, binutils and kernel builds. Each of those config hardcode
the CROSS_COMPILER string and have their own build directory. In each
case, I want to be able to just run "make O=/src/obj/v3.0-arm
oldnoconfig all" without having to worry about anything else.
