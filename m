Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2CUNcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:32:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2CUNcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:32:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lubos Lunak <l.lunak@suse.cz>
Subject: Re: [PATCH] do not export kernel's NULL #define to userspace
Date: Wed, 21 Mar 2012 13:32:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201203211408.25040.l.lunak@suse.cz>
In-Reply-To: <201203211408.25040.l.lunak@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201203211332.06018.arnd@arndb.de>
X-Provags-ID: V02:K0:othU+VjqSMOf35yQFa9rJm7Xst6EwelM+Zl4oyVqnGa
 YtklcRki6zZxFeQkLetyZUvBS9+k16uku6Tp1eBrSlob182ebX
 P/RKIq6HqACwY5TYgOfNfRDai8BHFQMtm1L88Ys1xb5B8km0nY
 kBaKE4XtW/lTxCBEvSxuLKuaRXPJIvp0BG//kEtgKJHoUz4NEa
 +BPFgmwSFGbrSDHm8MLKKdkdezHzAbCXtKFvN5lOXgGgthSTeN
 5IPOhDv5Pid6KAWV9286E92CZX+p2rGd1eqNtq0V7Z1VhwR/B+
 H6Tp+q519dsr4bKBTeXuIDRqw0zH0ROgNN5a37DOMpQSbtPoQ/
 Ak3ByhqNWy/yyf1B4yRk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2012, Lubos Lunak wrote:
> GCC's NULL is actually __null, which allows detecting some questionable
> NULL usage and warn about it. Moreover each platform/compiler should have
> its own stddef.h anyway (which is different from linux/stddef.h).
> So there's no good reason to leak kernel's NULL to userspace and
> override what the compiler provides.
> 
> Signed-off-by: Luboš Luňák <l.lunak@suse.cz>

Yes, this looks like a bug, but I'm not sure that the solution is
sufficient. Have you checked the other exported header files
for whether they use NULL after including linux/stddef.h?

If so, we might have to replace it with a __KERNEL_NULL constant
or something, like we do for the stuff in linux/types.h, so we
don't accidentally break user applications that rely on the
header files to be self-contained. 

I think there is at least a NULL usage in linux/wireless.h and some
netfilter headers.

	Arnd
