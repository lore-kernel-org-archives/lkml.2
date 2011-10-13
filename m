Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1JMVMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab1JMVMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:12:18 -0400
Message-ID: <4E97541F.9050805@redhat.com>
Date: Thu, 13 Oct 2011 17:11:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Satoru Moriya <satoru.moriya@hds.com>, Con Kolivas <kernel@kolivas.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, Hugh Dickins <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110111612120.5236@chino.kir.corp.google.com> <65795E11DBF1E645A09CEC7EAEE94B9CB516D459@USINDEVS02.corp.hds.com> <alpine.DEB.2.00.1110131337580.24853@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110131337580.24853@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 04:48 PM, David Rientjes wrote:

> We'll never know the future and how much memory a latency-sensitive
> application will require 100ms from now.  The only thing that we can do is
> (i) identify the latency-sensitive app, (ii) reclaim more aggressively for
> them, and (iii) reclaim additional memory in preparation for another

This is why I proposed a watermark solution.

> burst.  At some point, though, userspace needs to be responsible to not
> allocate enormous amounts of memory all at once and there's room for
> mitigation there too to preallocate ahead of what you actually need.

Userspace cannot be responsible, for the simple reason that
the allocations might be done in the kernel.

Think about an mlocked realtime program handling network
packets. Memory is allocated when packets come in, and when
the program calls sys_send(), which causes packets to get
sent.

I don't see how we can make userspace responsible for
kernel-side allocations.

I did not propose the extra_free_kbytes patch because I
like it, or out of laziness, but because I truly have not
come up with a better solution.

So far, neither this thread (which is unfortunate).
