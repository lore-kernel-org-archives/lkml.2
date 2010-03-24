Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0CXNdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:33:24 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20346 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab0CXNdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:33:22 -0400
X-IronPort-AV: E=Sophos;i="4.51,301,1267419600"; 
   d="scan'208";a="89407457"
Subject: Re: [PATCH 01/10] irq: move some interrupt arch_* functions into
 struct irq_chip.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Paul Mundt <lethal@linux-sh.org>
CC: Yinghai Lu <yinghai@kernel.org>,
       "michael@ellerman.id.au" <michael@ellerman.id.au>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lguest@ozlabs.org" <lguest@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100323071006.GJ13417@linux-sh.org>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
	 <1269221770-9667-2-git-send-email-yinghai@kernel.org>
	 <1269222962.3534.12.camel@concordia> <4BA6E4D1.6080704@kernel.org>
	 <20100323071006.GJ13417@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 24 Mar 2010 13:33:17 +0000
Message-ID: <1269437597.10129.67623.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 07:10 +0000, Paul Mundt wrote:

> The function pointer thing itself is also a bit unorthodox to say the
> least. You're introducing and passing around an opaque type just so you
> can get to a 'return 0' in the xen case as far as I can tell,

The ultimate aim is to have Xen use the chip data to store the event
channel information relating to each IRQ instead of keeping it in a
static NR_IRQs array, the new function only returns 0 as a placeholder
until this can be put in place (which depends on these changes), it
could as well have been left out for the time being (e.g. passing NULL
function pointer in the Xen case or whatever).

> so you
> could also just make arch_init_chip_data() a weak symbol and clobber it
> in the xen case, no?

A single kernel is able to boot native or Xen so a weak symbol doesn't
really work, having the function pointer at the arch level is one
similar option, I've replied to Thomas' similar suggestion.

Ian.

