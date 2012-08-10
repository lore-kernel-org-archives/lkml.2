Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab2HJVIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 17:08:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45432 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2HJVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:08:27 -0400
Date: Fri, 10 Aug 2012 14:08:24 -0700 (PDT)
Message-Id: <20120810.140824.1942743961348792495.davem@davemloft.net>
To: jengelh@inai.de
Cc: dhowells@redhat.com, arnd@arndb.de, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com
Subject: Re: [PATCH] MPILIB: Provide count_leading/trailing_zeros() based
 on arch functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.01.1208101451280.23731@frira.zrqbmnf.qr>
References: <5723.1342794099@warthog.procyon.org.uk>
	<20120720.174641.159144353919647856.davem@davemloft.net>
	<alpine.LNX.2.01.1208101451280.23731@frira.zrqbmnf.qr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@inai.de>
Date: Fri, 10 Aug 2012 14:51:49 +0200 (CEST)

> 
> On Saturday 2012-07-21 02:46, David Miller wrote:
>>> Arnd Bergmann <arnd@arndb.de> wrote:
>>> 
>>>> I don't generally like to put stuff into asm-generic when it's unlikely
>>>> to be overridden by architectures. It would really belong into
>>>> include/linux, but then again we have all the other bitops in asm-generic
>>>> as well, so whatever...
>>> 
>>> Some arches (such as Sparc, I think) have count-leading-zero instructions.
>>
>>Yes, newer sparc64 chips have leading-zero-detect, and I was pretty
>>sure that powerpc had something similar.  It's called count-leading-
>>zeros or something like that.
> 
> And gcc has a __builtin_clz.

Which I can't use.  I have to patch the code at run time based upon
whether the cpu has the 'lzd' instruction or not.
