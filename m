Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2CEKVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:21:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2CEKVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:21:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alex Shi <alex.shi@intel.com>
Subject: Re: [RFC patch] spindep: add cross cache lines checking
Date: Mon, 5 Mar 2012 09:41:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: tglx@linutronix.com, "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com
References: <1330917630.18835.44.camel@debian> <1330917889.18835.46.camel@debian> <1330926234.18835.51.camel@debian>
In-Reply-To: <1330926234.18835.51.camel@debian>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203050941.56502.arnd@arndb.de>
X-Provags-ID: V02:K0:mdgG4sIoUktx/DyksHu8oJQekGDBpwXEjzrB7Mvk+Jg
 ++CintgUEfeuoTtzfVxLO9dbOUHW+2golRxnE2JIzPxujJ2mhO
 RDTxexo991FKiSM+R9X7nqabBe4AjOg6tx6qYM6CckjqlJEgTC
 2uxE1J0bPmcOmYedroadeQ5varBcBQn5SAwk6A5IHXTMpOU918
 SWuG4yMrbcOdeiqiM/+18cLaSGpybKJrE9fx/JS5ezHDuQhYWH
 VH53xP0FMpnh7oCsuutHHY+zubnt3L0CLAVdT8Rb/tEsE/fXxA
 bpSFU+VzL9v5hpf9rdTTQOZOMV1bo/v3ffwx3mBIZAL/mvq25D
 /jK7R6NYGwRKuMOCoLzA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2012, Alex Shi wrote:
> Subject: [PATCH] lockdep: add cross cache lines checking
> 
> Modern x86 CPU won't hold whole memory bus when executing 'lock'
> prefixed instructions unless the instruction destination is crossing 2
> cache lines. If so, it is disaster of system performance.
> 
> Actually if the lock is not in the 'packed' structure, gcc places it
> safely under x86 arch. But seems add this checking in
> CONFIG_DEBUG_LOCK_ALLOC is harmless.

Have you tried making this a compile-time check using __alignof__?
I would say that any spinlock in a packed data structure is
basically a bug, even more so on most other architectures besides
x86.

	Arnd
