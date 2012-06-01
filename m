Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965216Ab2FAV5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:57:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57535 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280Ab2FAV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:57:43 -0400
Date: Fri, 1 Jun 2012 14:57:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Vladimir =?UTF-8?Q?'=CF=86-coder/phcoder'?= Serbinenko" 
	<phcoder@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add Apple NLS
Message-Id: <20120601145741.c6289ea9.akpm@linux-foundation.org>
In-Reply-To: <CAE9FiQVqPCRQbg8PShxbUeT5Z0gm88vm76QNT=btGCNRwGP2oA@mail.gmail.com>
References: <4FAFBE24.7000307@gmail.com>
	<20120517154707.c3dc2795.akpm@linux-foundation.org>
	<4FB5D1C8.7020305@gmail.com>
	<CAE9FiQVqPCRQbg8PShxbUeT5Z0gm88vm76QNT=btGCNRwGP2oA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012 12:36:11 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> On Thu, May 17, 2012 at 9:36 PM, Vladimir '__-coder/phcoder' Serbinenko
> <phcoder@gmail.com> wrote:
> >> Also, I note that the unicode files have
> >>
> >> __ __ __ MODULE_LICENSE("Dual BSD/GPL");
> >>
> >> Where did this come from? __Is this a thing you decided upon or is it
> >> unicode.org's license requirement?
> >>
> 
> looks like Makefile change is not right... it has hard code =m for new modules.
> 
> those line should be removed.

Yup.  This?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/nls/Makefile: remove bogus CONFIG_ assignments

I assume these were debug things whcih snuck through.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Vladimir Serbinenko <phcoder@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nls/Makefile |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN fs/nls/Makefile~fs-nls-makefile-remove-bogus-config_-assignemnts fs/nls/Makefile
--- a/fs/nls/Makefile~fs-nls-makefile-remove-bogus-config_-assignemnts
+++ a/fs/nls/Makefile
@@ -2,18 +2,6 @@
 # Makefile for native language support
 #
 
-CONFIG_NLS_MACCELTIC=m
-CONFIG_NLS_MACCENTEURO=m
-CONFIG_NLS_MACCROATIAN=m
-CONFIG_NLS_MACCYRILLIC=m
-CONFIG_NLS_MACGAELIC=m
-CONFIG_NLS_MACGREEK=m
-CONFIG_NLS_MACICELAND=m
-CONFIG_NLS_MACINUIT=m
-CONFIG_NLS_MACROMANIAN=m
-CONFIG_NLS_MACROMAN=m
-CONFIG_NLS_MACTURKISH=m
-
 obj-$(CONFIG_NLS)		+= nls_base.o
 
 obj-$(CONFIG_NLS_CODEPAGE_437)	+= nls_cp437.o
_

