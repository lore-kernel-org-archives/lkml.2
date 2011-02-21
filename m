Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1BUHtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 02:49:50 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59034 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486Ab1BUHtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 02:49:47 -0500
Date: Sun, 20 Feb 2011 23:49:47 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
Message-ID: <20110221074947.GA31152@dtor-ws.eng.vmware.com>
References: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
 <20110217.140119.39175251.davem@davemloft.net>
 <20110217221957.GA11244@dtor-ws.eng.vmware.com>
 <20110217.142320.102554706.davem@davemloft.net>
 <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
 <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
 <1298074455.2460.85.camel@pasglop>
 <87pqqmrq9q.fsf@rustcorp.com.au>
 <AANLkTinFgma3F7ETwC8Mho7wdDK4V2b+Ao__npJNAW8j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinFgma3F7ETwC8Mho7wdDK4V2b+Ao__npJNAW8j@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 08:38:46AM +0100, Geert Uytterhoeven wrote:
> On Mon, Feb 21, 2011 at 05:00, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> Except that .long is 32-bit on ppc64 :-( You need .llong for 64-bit.
> >
> > OK, all options suck.  Do we want the workaround or not?
> 
> We can discuss about that until someone gets bitten by that.
> 
> But please fix the "aligned(sizeof(void *))"-in-one-place-only issue.
> 

How about this one then?

Thanks.

-- 
Dmitry

>From f0e0e10b58b22047e36e21a022abf5e86b5819c2 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dtor@vmware.com>
Date: Fri, 4 Feb 2011 13:30:10 -0800
Subject: [PATCH] module: explicitly align module_version_attribute structure

We force particular alignment when we generate attribute structures
when generation MODULE_VERSION() data and we need to make sure that
this alignment is followed when we iterate over these structures,
otherwise we may crash on platforms whose natural alignment is not
sizeof(void *), such as m68k.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 include/linux/module.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index e7c6385..de5cd21 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -62,7 +62,7 @@ struct module_version_attribute {
 	struct module_attribute mattr;
 	const char *module_name;
 	const char *version;
-};
+} __attribute__ ((__aligned__(sizeof(void *))));
 
 struct module_kobject
 {
-- 
1.7.3.2

