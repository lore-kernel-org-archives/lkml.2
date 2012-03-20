Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2CTQR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:17:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56201 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2CTQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPiS6wCUgYDdbSmjCzMaMv8CkZCazGvg91fqiv23W=ZeUObtdA@mail.gmail.com>
References: <CAPiS6wCUgYDdbSmjCzMaMv8CkZCazGvg91fqiv23W=ZeUObtdA@mail.gmail.com>
Date: Tue, 20 Mar 2012 18:17:51 +0200
Message-ID: <CAPiS6wDc8=7yZxDNph7g1hAT7Z81P_xLJKxo79TYhq6D4m_Q+Q@mail.gmail.com>
Subject: Re: memcpy() crash on x86-64 (reproducible)
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:42 AM, Paulius Zaleckas
<paulius.zaleckas@gmail.com> wrote:
> When dumping registers with 'ethtool -d <interface>' my PC freezes
> (99% reproducible).
> Only hard reset helps. My network card uses r8169 driver.
> It uses memcpy_fromio() to copy PCI space registers to buffer.
> If I change it to simple for(...) cycle with readl() it does NOT crash
> and works as expected.
>
> This happens with my work PC and the same happens on my colleagues
> identical PC with CPU:
> Intel(R) Core(TM) i7-2700K CPU @ 3.50GHz
>
> However this crash does not happen on my home PC with AMD Phenom CPU.
> It also has realtek network card and uses the same r8169 driver.
>
> I know how to compile :) and I am willing to help find and fix this bug.

I have tried different versions of memcpy available in kernel:
__memcpy() - crashes
memcpy_c() - crashes
memcpy_c_e() - works as expected
__inline_memcpy() - works as expected

About crash: actually PC freezes for ~20s, then unfreezes, but
responds very slowly and after ~1min freezes completely.
One time I was able to see dmesg output and there was
backtrace about some process stuck for too long and then
it switched to some different timing source because hpet was
unstable.
