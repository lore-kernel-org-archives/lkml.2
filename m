Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3AHRYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:24:33 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37961 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3AHRYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:24:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZtpubRhSF3K=B91oHXMPaTX6jGNLZn+e6ks83JS92k=bw@mail.gmail.com>
References: <CAAJw_Zv8O1LPX-jmpg3fvNrWMLWbQC=1tbZ6T7nsm6cyC008fg@mail.gmail.com>
 <CA+55aFxXAMz5Sg44e-TJ0P=LY+3VkfdNtZMS3EJEHdztY2kC0Q@mail.gmail.com> <CAAJw_ZtpubRhSF3K=B91oHXMPaTX6jGNLZn+e6ks83JS92k=bw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Jan 2013 09:24:11 -0800
X-Google-Sender-Auth: t_ZlaosZNJKh_3Shh0WsL0CPr48
Message-ID: <CA+55aFyEE6pM2gVfgd3xjQR5rF6ij5pG7BXjkH+C5aHbxAk6mg@mail.gmail.com>
Subject: Re: 2nd attempt: help with dma_alloc_coherent() + dma_free_coherent()
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 9:17 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
> Interesting, but there are 54 lines under the kernel directories that
> use "dma_alloc_coherent(NULL," followed by "dma_free_coherent(NULL,"

As mentioned, it works on some platforms. That doesn't make it right.

> So, shouldn't they be fixed as well? ... unless they are so old that
> nobody cares anymore ...

Some of the ones I saw are in MIPS or blackfin. Others probably *are*
so old that nobody cares, and happen to work because there's iommu's
or other things that simply don't care about the device.

> # find . -exec grep -H "dma_alloc_coherent(NULL" {} \; | wc -l
> 54
>
> #find . -exec grep -H "dma_free_coherent(NULL" {} \; | wc -l
> 72

Let me tell you about "git grep", so that you never need to do that
disgusting "find -exec grep" ever again.

It does threading, it's fast, and it just works.

                Linus
