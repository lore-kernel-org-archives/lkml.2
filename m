Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2DZOR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:17:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37707 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2DZOR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:17:26 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120426114229.GG3207@opensource.wolfsonmicro.com>
References: <20120426114229.GG3207@opensource.wolfsonmicro.com>
Date: Thu, 26 Apr 2012 07:17:25 -0700
Message-ID: <CAOesGMj2eZvWek86D2MKQMPY9qAsC0D2MsYyN-+RPUr5gDFn4A@mail.gmail.com>
Subject: Re: Default Kconfig state for hw_random drivers
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 4:42 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> An Atmel hw_random driver just appeared in -next.  Since it's just a
> regular platform device it has no dependencies on any particular
> platform so following the behaviour of other hw_random drivers it's set
> to default enabled if hw_random is enabled, even on non-Atmel platforms.
>
> This doesn't feel like the right thing to do - it'd mean that most of
> the embedded RNGs would end up getting enabled by default which probably
> isn't what we want.

Indeed, thanks for catching this. The driver isn't new but it had a
previous dependency on just one AT91 chip family.

Looking at other options in the same Kconfig, it would be appropriate
to make it depend on ARCH_AT91 instead.

Nicolas?


-Olof
