Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab1EBL0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 07:26:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1EBL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 07:26:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Date: Mon, 2 May 2011 13:26:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linaro-mm-sig@lists.linaro.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Catalin Marinas <catalin.marinas@arm.com>,
        KyongHo Cho <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org
References: <201104212129.17013.arnd@arndb.de> <20110429221554.GD14871@n2100.arm.linux.org.uk> <8yapqo1ogrk.fsf@huya.qualcomm.com>
In-Reply-To: <8yapqo1ogrk.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105021326.09725.arnd@arndb.de>
X-Provags-ID: V02:K0:lB071iEUBTwrPUo6S7fxhOelZc+EwCM+cBQ/t2JdqeM
 E+W9kvV5ZGi0OIC9WMUrWQm9DAnPR2YbvhcyosV1ZWEQLi+ptx
 poHoDCOj+bH2AhiDr/VBzQgeHBRWOrsN9PYo96UK/VhKh/9+im
 uDQp46QHt55Nt4yBERuFbG69NnkPsyqBut7IeiKg/UEtXCy+vB
 T7ojosH1rKLUSD4eBLNow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 May 2011, David Brown wrote:
> I'll confirm this from the Qualcomm side as well.  You cannot have
> multiple inconsistent mappings of the same page without having difficult
> to find problems.

I believe Catalin was referring to the case where you have only
one nonconsistent (cacheable) mapping plus multiple consistent
(cacheable) mappings. I don't think anyone has suggested doing
DMA to a page that has multiple nonconsistent mappings with
virtually indexed caches.

> The spec clarifications appear to give ways of dealing with it if it
> happens, and bounds on what can go wrong, but I wouldn't call it
> something we want to do normally.  Corrupt data is arguably less of a
> problem than nasal demons, but still a problem.

Anything that has a theoretical chance of corrupting data is not an
option, but I'd really like to see what the clarified spec says
about this. Even if there is a way to legally leave a page for
dma_alloc_coherent in the linear mapping, it might turn out to
be harder to do than using highmem pages or unmapping supersections
at run time as was suggested.

	Arnd
