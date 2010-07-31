Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0GaJih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 05:38:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0GaJie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 05:38:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: stepanm@codeaurora.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Sat, 31 Jul 2010 11:37:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: "Roedel, Joerg" <joerg.roedel@amd.com>,
        "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "dwalker@codeaurora.org" <dwalker@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100729123512Y.fujita.tomonori@lab.ntt.co.jp> <201007302359.08188.arnd@arndb.de> <2d92bd7e819dd81e2f64d358918711d3.squirrel@www.codeaurora.org>
In-Reply-To: <2d92bd7e819dd81e2f64d358918711d3.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007311137.55826.arnd@arndb.de>
X-Provags-ID: V02:K0:09pP3xsi031hIbjOAH7XobR+67xxURSYM9zrtS7weTp
 1P+FFzfUaWSVDCxKniilBvLiDIN0MUUIPIThTwV5y6gPxXqiVu
 9ixrJQ1CofHpu/I2zZAJlXgEhKj0CgoQ4CX5JMhiJxVhM2OyRO
 67qm8D9HIuiesWSmXiZgx6XqkirPyP5PIghdnUPjIYp9Wkw/NP
 i7VtMMuPjATTXhJLzwONA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 July 2010 00:58:00 stepanm@codeaurora.org wrote:
> > If you really need multiple domains across multiple IOMMUs, I'd suggest that
> > we first merge the APIs and then port your code to that, but as a first step
> > you could implement the standard dma-mapping.h API, which allows you to use
> > the IOMMUs in kernel space.
> 
> One of our uses cases actually does involve using domains pretty much as
> you had described them, though only on one of the IOMMUs. That is, the
> domain for that IOMMU basically abstracts its page table, and it is a
> legitimate thing to switch out page tables for the IOMMU on the fly. I
> guess the difference is that you described the domain as the set of
> mappings made on ALL the IOMMUs, whereas I had envisioned there being one
> (or more) domains for each IOMMU.

Can you be more specific on what kind of device would use multiple domains
in your case and how you intend to use them? Is this for some kind of DSP
interacting with user processes?

This seems to be a scenario that we haven't dealt with before (or perhaps
avoided intentionally), so if we need to make API changes, we should all
understand what we need them for. It's no problem to extend the API if you
have good reasons for using multiple domains, but I also want to make sure
that there isn't also a way to achieve the same or better result with the
current APIs.

	Arnd
