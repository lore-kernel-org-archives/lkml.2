Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1HAQkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:40:43 -0400
Received: from relais.videotron.ca ([24.201.245.36]:16876 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1HAQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:40:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 01 Aug 2011 17:40:35 +0100 (BST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Kyle Moffett <kyle@moffetthome.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Zoltan Devai <zdevai@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        chris@zankel.net, linux-am33-list@redhat.com, trivial@kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, cmetcalf@tilera.com,
        linux-arm-kernel@lists.infradead.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] Remove remaining references of CONFIG_GENERIC_TIME
In-reply-to: <CACqU3MUoxSNmcYsSF4zOTgADdedb7TcciPuBPMviG02M5oUPDQ@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1108011737030.18706@xanadu.home>
References: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
 <20110801083614.GC15578@n2100.arm.linux.org.uk>
 <CAMuHMdUpTDSRP_JmWqcCBtYwzna0hwmaBshpiF8kgvqoNcqYZA@mail.gmail.com>
 <20110801101410.GE15578@n2100.arm.linux.org.uk>
 <CAMuHMdUiLjMVwOqKPF6tHLpPxROrx=rRf3ednfTLrwGuZ2VF7A@mail.gmail.com>
 <CACqU3MVUxTYmD+4VGBAeN8PTs83fR0xQQrQS5h4QGMZXgMxEvA@mail.gmail.com>
 <CAGZ=bqL=VAx5jnSBkE2q5KJSY_+An-VRTRAzJmJ3waQUvrRFFg@mail.gmail.com>
 <CACqU3MUoxSNmcYsSF4zOTgADdedb7TcciPuBPMviG02M5oUPDQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011, Arnaud Lacombe wrote:

> Moreover, this approach is deemed to fail. The current symbol
> namespace is tied to an arch, so whenever you do:
> 
> arch/arm/Kconfig:
> config FOO
>     bool
> 
> config BAZ
>     bool
> 
> drivers/cpufreq/Kconfig
> config BAR
>     depends on ARM && FOO
>     select BAZ
> 
> You will end up triggering the warning for every ARCH != ARM...

You can keep a state for those symbols with regard to their level of 
reference.  Surely if ARM isn't true, BAZ is not "actively" referenced 
in the end.


Nicolas
