Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2JOTTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:19:33 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53280 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2JOTTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:19:31 -0400
Message-ID: <507C61B2.9060503@linux.vnet.ibm.com>
Date: Mon, 15 Oct 2012 14:19:14 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Reply-To: cover.1349621096.git.markus@oberhumer.co
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
CC: Robert Jennings <rcj@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Johannes Stezenbach <js@sig21.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 0/3] Update LZO compression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101519-9360-0000-0000-00000BB8CBE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As requested by akpm I am sending my "lzo-update" branch at
> 
>   git://github.com/markus-oberhumer/linux.git lzo-update
> 
> to lkml as a patch series created by "git format-patch -M v3.5..lzo-update".
> 
> You can also browse the branch at
> 
>   https://github.com/markus-oberhumer/linux/compare/lzo-update
> 
> and review the three patches at
> 
>   https://github.com/markus-oberhumer/linux/commit/7c979cebc0f93dc692b734c12665a6824d219c20
>   https://github.com/markus-oberhumer/linux/commit/10f6781c8591fe5fe4c8c733131915e5ae057826
>   https://github.com/markus-oberhumer/linux/commit/5f702781f158cb59075cfa97e5c21f52275057f1

As this relates to my work on zcache, I just tested these patches on PPC64 and
they cause the LZO crypto module to fail its self-test:

[    0.521137] alg: comp: Compression test 1 failed for lzo-generic: output len = 62

I built the exact same kernel for x86_64 and all is fine.  I suspect an endianness
related bug, but I haven't looked at the code that closely yet.

Any ideas?  I'd be happy to test any potential fixes.

Seth

