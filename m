Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1EDOIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:08:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43483 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1EDOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bYV/JWifkIy6MCKDQSIzdCK1gRQcCqvbFN9dXq+f/q5vfFF86u998Tarb+YBLEsrwA
         ObCK5LDD9aUHZM3h0gdxkXDJCEaMkpkT8xvsZ7JVZcrxzGEE9rJ90h+Yg8hVBex0zIAp
         J3q9GRoMNIvmV+BEuiTNRfl2bgJmQceEOsxOQ=
Date: Wed, 4 May 2011 16:07:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504140742.GB17294@htj.dyndns.org>
References: <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <alpine.DEB.2.00.1105040902210.5495@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105040902210.5495@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Wed, May 04, 2011 at 09:04:19AM -0500, Christoph Lameter wrote:
> The above should not happen. If a kernel config indicates that there is no
> cmpxchg16b/cmpxchg8b available then we need to not compile the path that
> uses cmpxchg8b/cmpxchg16b. Guess we need CMPXCHG_DOUBLE_LOCAL or so.

But regardless of that, if the code requires irq safety it should be
using irqsafe_* operations.  CMPXCHG_LOCAL is an optimization hint and
doesn't necessarily imply stronger synchronization guarantees.  In
addition, there's no downside to using irqsafe_* variant when CPU
actually supports cmpxchg[_double].  So, let's first fix that and
think about CMPXCHG[_DOUBLE]_LOCAL or whatnot later.

Thank you.

-- 
tejun
