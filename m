Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2HTLRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:17:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab2HTLRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:17:46 -0400
Message-ID: <50321CD3.5050501@redhat.com>
Date: Mon, 20 Aug 2012 07:17:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Hugh Dickins <hughd@google.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Repeated fork() causes SLAB to grow without bound
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu> <502D42E5.7090403@redhat.com> <20120818000312.GA4262@evergreen.ssec.wisc.edu> <502F100A.1080401@redhat.com> <alpine.LSU.2.00.1208200032450.24855@eggly.anvils> <CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>
In-Reply-To: <CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 05:39 AM, Michel Lespinasse wrote:

> I would still prefer if we could just remove the anon_vma_chain stuff, though.

If only we could.

That simply replaces a medium issue at fork time, with the
potential for a catastrophic issue at page reclaim time,
in any workload with heavily forking server software.

Without the anon_vma_chains, we end up scanning every single
one of the child processes (and the parent) for every COWed
page, which can be a real issue when the VM runs into 1000
such pages, for 1000 child processes.

Unfortunately, we have seen this happen...

-- 
All rights reversed
