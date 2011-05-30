Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab1E3LGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:06:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1E3LGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:06:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Woodhouse <dwmw2@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Date: Mon, 30 May 2011 13:05:58 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
References: <1306707270.2029.377.camel@i7.infradead.org> <20110530072300.GA9802@elte.hu> <1306745835.2029.389.camel@i7.infradead.org>
In-Reply-To: <1306745835.2029.389.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105301305.59166.arnd@arndb.de>
X-Provags-ID: V02:K0:odHoFDGXt9qsLqcbl54QOFIcp6PanXzHNBz+6XFKh1k
 nf2s/sAqKaR9bs0ncGYeVq0uJWE+/EXrtXi5XRLYxkRgftZWGy
 O2OMf2R0FsuDvAj1wvs9YlcReUqhigcRI87v5b8Q2QjH8VyPtU
 6I/5lppnObnNyLDY4RxARhvTEDremYpZCmRLptvQMlmdeAUJ+e
 nXWMiDLBBRGlEiWqd1FGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011, David Woodhouse wrote:
> And as I said, it's still an incomplete solution if you actually want a
> 'filtered randconfig' to do anything *useful*. You'd be much better off
> implementing a real filtered randconfig that allows you to give a list
> of hard-coded options, rather than relying on a dirty hack that only
> actually sets one option of the many that you might need to
> 'hard-code' if you actually wanted a useful build.

I'm actually looking for a way to do filtered randconfig (and
all{yes,mod,no}config) for ARM, so hopefully we can come up with
something useful.

Our problem today is that we have not just two but dozens of
incompatible platforms, and with randconfig every 'choice'
statements still just gets its default, which makes randconfig
builds fairly useless.

What I'd like to see is one or both of these two behaviors:

* Take a defconfig file (with the new format that only sets
  non-default options), and keep everything in there but
  apply the rand/no/yes/mod-config to all other symbols.

* Randomize all settings, including choice statements.

	Arnd
