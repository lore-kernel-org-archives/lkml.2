Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab1HARUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:20:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43484 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1HARU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1108011737030.18706@xanadu.home>
References: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
	<20110801083614.GC15578@n2100.arm.linux.org.uk>
	<CAMuHMdUpTDSRP_JmWqcCBtYwzna0hwmaBshpiF8kgvqoNcqYZA@mail.gmail.com>
	<20110801101410.GE15578@n2100.arm.linux.org.uk>
	<CAMuHMdUiLjMVwOqKPF6tHLpPxROrx=rRf3ednfTLrwGuZ2VF7A@mail.gmail.com>
	<CACqU3MVUxTYmD+4VGBAeN8PTs83fR0xQQrQS5h4QGMZXgMxEvA@mail.gmail.com>
	<CAGZ=bqL=VAx5jnSBkE2q5KJSY_+An-VRTRAzJmJ3waQUvrRFFg@mail.gmail.com>
	<CACqU3MUoxSNmcYsSF4zOTgADdedb7TcciPuBPMviG02M5oUPDQ@mail.gmail.com>
	<alpine.LFD.2.00.1108011737030.18706@xanadu.home>
Date: Mon, 1 Aug 2011 13:20:26 -0400
Message-ID: <CACqU3MU_oq+RYydenKG_8U08rdJ-N+2hftH+2xEPZU0uVP6i5A@mail.gmail.com>
Subject: Re: [PATCH] Remove remaining references of CONFIG_GENERIC_TIME
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Zoltan Devai <zdevai@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        chris@zankel.net, linux-am33-list@redhat.com, trivial@kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, cmetcalf@tilera.com,
        linux-arm-kernel@lists.infradead.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 1, 2011 at 12:40 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Mon, 1 Aug 2011, Arnaud Lacombe wrote:
>
>> Moreover, this approach is deemed to fail. The current symbol
>> namespace is tied to an arch, so whenever you do:
>>
>> arch/arm/Kconfig:
>> config FOO
>>     bool
>>
>> config BAZ
>>     bool
>>
>> drivers/cpufreq/Kconfig
>> config BAR
>>     depends on ARM && FOO
>>     select BAZ
>>
>> You will end up triggering the warning for every ARCH != ARM...
>
> You can keep a state for those symbols with regard to their level of
> reference.  Surely if ARM isn't true, BAZ is not "actively" referenced
> in the end.
>
he :) we enter in compilers optimizations. As much as I agree with
you, that might not be trivial to implement given the internal,
ad-hoc, structure of kconfig. All of that would be useless if we had a
single global namespace.

 - Arnaud
