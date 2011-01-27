Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1A0IXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 03:23:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1A0IXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:23:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 4/4] x86: allow CONFIG_ISA_DMA_API to be disabled
Date: Thu, 27 Jan 2011 09:23:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Russell King <linux@arm.linux.org.uk>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1101261912200.7809@chino.kir.corp.google.com> <alpine.DEB.2.00.1101261914060.7809@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1101261914060.7809@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101270923.37476.arnd@arndb.de>
X-Provags-ID: V02:K0:MN0ZKXFSVK+4dgafS5lrRX17JJ0KposnXUjltAfMxj9
 AclgvaHp3k30Fk+76mz9s2Q2ZFmOzvugq++NTYj6QQBf/wP86M
 SX+N6WxBTbL01Qe1YamzIZrwtyRS6KTsav9ZmZriThD9DFv4oH
 82Mn2kMgo3t+JqNc80wqpZgdSWIwF5P+cD1imQkbYqS0edOedO
 g3lpSCzP+wmTIweGZO9cA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 January 2011 04:14:54 David Rientjes wrote:
> 
> Not all 64-bit systems require ISA-style DMA, so allow it to be
> configurable.  x86 utilizes the generic ISA DMA allocator from
> kernel/dma.c, so require it only when CONFIG_ISA_DMA_API is enabled.
> 
> Disabling CONFIG_ISA_DMA_API is dependent on x86_64 since those machines
> do not have ISA slots and benefit the most from disabling the option (and
> on CONFIG_EXPERT as required by H. Peter Anvin).

But the x86_64 machines can also run 32 bit kernel, and I would expect
that they don't need ISA DMA in that configuration either.

I think it would make sense to let the CONFIG_EXPERT user disable
DMA for 32 bit as well.

	Arnd
