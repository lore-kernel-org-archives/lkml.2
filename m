Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1FMNhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:37:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab1FMNhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:37:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] fb.h: ARM uses __raw_{read/write}
Date: Mon, 13 Jun 2011 15:37:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
References: <201106101731.08578.hartleys@visionengravers.com> <20110613040003.GA29731@linux-sh.org> <20110613100819.GA26914@1n450.cable.virginmedia.net>
In-Reply-To: <20110613100819.GA26914@1n450.cable.virginmedia.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106131537.10698.arnd@arndb.de>
X-Provags-ID: V02:K0:eAFWM8OhZPiug7SLnYZ5Jb5mRdrN9aKe8ikHegHznwk
 fEFK1S4JOmx8GN8IIsCZPo7MA0T0PymQSgmCNyU22McN31mVrx
 /Z6wjcvUGeV1AwMBVcWv76xr+MvtQUXitbkwS14I8wtoHKNUKx
 V9Bt15jxYsWOiP+NTXlJJuNDbjfVFZqAzrJRFiskeF+NruhtS8
 mWu8A38cQaGy0o5eSbOpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 June 2011 12:08:19 Catalin Marinas wrote:
> The change proposed by Hartley wouldn't make much difference from the
> current volatile accesses (__raw_* accessors are implemented as volatile
> on ARM).

I guess it would mainly make a difference if we get a platform where
the PCI bus window is not in the same address space as the regular
physical memory and the accessors actually need to do a computation
on the address. AFAICT, ARM does not currently have any such platform
and I would hope that it says that way.

> I think the memcpy_(from|to)io could be optimised on ARM to only add a
> barrier before or after he copying loop.

Agreed, good idea.

	Arnd
