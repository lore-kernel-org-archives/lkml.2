Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab1ERSvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:51:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:37634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485Ab1ERSvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:51:20 -0400
X-ExtLoop1: 1
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 18 May 2011 11:49:16 -0700
Subject: RE: [PATCH 9/9] x86/lib/memset_64.S: Optimize memset by enhanced
 REP MOVSB/STOSB
Thread-Topic: [PATCH 9/9] x86/lib/memset_64.S: Optimize memset by enhanced
 REP MOVSB/STOSB
Thread-Index: AcwViuRO9iEw7exvS+qwf42UDEs8kAAACxHg
Message-ID: <493994B35A117E4F832F97C4719C4C04011505C812@orsmsx505.amr.corp.intel.com>
References: <1305671358-14478-1-git-send-email-fenghua.yu@intel.com>
 <1305671358-14478-10-git-send-email-fenghua.yu@intel.com>
 <08d8c27c0495452cad52b62b362dd1d1.squirrel@www.firstfloor.org>
 <493994B35A117E4F832F97C4719C4C04011505C39D@orsmsx505.amr.corp.intel.com>
 <9317a84b59d0a78a4b8e304ac2da490a.squirrel@www.firstfloor.org>
 <493994B35A117E4F832F97C4719C4C04011505C7DC@orsmsx505.amr.corp.intel.com>
 <20110518183913.GA12317@one.firstfloor.org>
In-Reply-To: <20110518183913.GA12317@one.firstfloor.org>
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

> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Wednesday, May 18, 2011 11:39 AM
> To: Yu, Fenghua
> Cc: Andi Kleen; Ingo Molnar; Thomas Gleixner; H Peter Anvin; Mallick,
> Asit K; Linus Torvalds; Avi Kivity; Arjan van de Ven; Andrew Morton;
> linux-kernel
> Subject: Re: [PATCH 9/9] x86/lib/memset_64.S: Optimize memset by
> enhanced REP MOVSB/STOSB
> 
> > I use gcc 4.3.2 installed by FC10 to build kernel with defconfig.
> Only memcpy is built with gcc builtin and inline memcpy. All of others
> (i.e. memset, clear_page, memmove, and copy_user) call the kernel lib.
> >
> > It's easy to check this by disassembling kernel binary.
> 
> gcc has a complex set of heuristics. For example if it cannot decide
> the length or the alignment it calls the kernel code. Otherwise
> it inlines.
> 
> So just looking at a few examples won't give you the whole picture.

What gcc 4.3.2 handles memcpy in kernel is to put inline code in kernel. Gcc 4.3.2 doesn't generate code to call kernel memcpy. Other version may do this. But not 4.3.2.

Thanks.

-Fenghua
