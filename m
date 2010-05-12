Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0ELMg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:36:29 -0400
Received: from mailgw.tensilica.com ([65.119.96.134]:45799 "EHLO
	mailgw.tensilica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab0ELMg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:36:27 -0400
From: Marc Gauthier <marc@tensilica.com>
To: Mike Frysinger <vapier.adi@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "npiggin@suse.de" <npiggin@suse.de>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
       "jw@emlix.com" <jw@emlix.com>, "cl@linux.com" <cl@linux.com>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "mpm@selenic.com" <mpm@selenic.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "os@emlix.com" <os@emlix.com>,
       "Michael.Hennerich@analog.com" <Michael.Hennerich@analog.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dg@emlix.com" <dg@emlix.com>, "osw@emlix.com" <osw@emlix.com>,
       "rientjes@google.com" <rientjes@google.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
       "chris@zankel.net" <chris@zankel.net>,
       Piet Delaney <Piet.Delaney@tensilica.com>
Date: Wed, 12 May 2010 05:35:45 -0700
Subject: RE: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 	cache lines
Thread-Topic: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 	cache lines
Thread-Index: AcrxjLEP6L7fBdwbQ8OeddDnMl6TFgAQS6AQ
Message-ID: <522C1DF17AF50042AD8AE87F7887BD3D01635495D3@exch.hq.tensilica.com>
References: <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
 	<522C1DF17AF50042AD8AE87F7887BD3D0163549554@exch.hq.tensilica.com>
 	<20100512030350.GJ15903@laptop>
 <20100512122323J.fujita.tomonori@lab.ntt.co.jp>
 <AANLkTine8JmtsUo3_z6Cwdgm3LINCkJ9jL21r9eQWRm8@mail.gmail.com>
In-Reply-To: <AANLkTine8JmtsUo3_z6Cwdgm3LINCkJ9jL21r9eQWRm8@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Tue, May 11, 2010 at 23:23, FUJITA Tomonori wrote:
>> Seems that kmalloc is not cacheline aligned on some architectures but
>> they works. Probably, we might be just lucky because in general they
>> allocate larger buffers than 64 for DMA via kmalloc and the buffers
>> are aligned on the size?
>
> i think the magic combo is:
>  - DMA buffer is written to (receive)
[...]
>  - only on arches that need software cache coherency

In particular, when the architecture port uses cache invalidates that
throw away dirty lines.  They're equivalent to writing old data to a
cache line, so an unrelated kmalloc allocation in the same cache line
gets corrupted.

So true, not all architectures need the extra alignment.
(And maybe some get lucky too, don't know.)

-Marc

PS.  Sorry about the gratuitous [LKML] in the subject line, mea culpa.
