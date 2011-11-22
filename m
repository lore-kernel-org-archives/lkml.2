Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab1KVUl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:41:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:20464 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab1KVUl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:41:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78932275"
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "linux-mips\@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf\@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and HPAGE_SIZE
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
	<alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com>
	<4ECACF68.3020701@gmail.com>
	<CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
	<4ECADD83.3090108@caviumnetworks.com>
	<CA+55aFzSNqCOFuvtEc2V1THVOsOVnz6NOa1U_9p5=Y4E=sj6qg@mail.gmail.com>
	<20111121155024.33b1b881.akpm@linux-foundation.org>
Date: Tue, 22 Nov 2011 12:41:55 -0800
In-Reply-To: <20111121155024.33b1b881.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 21 Nov 2011 15:50:24 -0800")
Message-ID: <m2sjlfvqi4.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> I wish people whose code had stuff like that would take a deep look at it.
>> 
>
> The original decision way back when was that huge pages shouldn't mess
> up the core VM too much.  One way in which we addressed that was to

IMHO this decision should really be revisited now.  Originally hugetlb
was pretty simple, but these days it has most of the functionality of a
full VM now. In fact with THP we have 3 different VM systems now, all
subtle different with different issues. And with THP hugetlb will be
even more widely used than it is today.

On the other hand there are strange gaps now, like shared memory
doesn't work with THP, but only with hugetlbfs.

It would be far better to think about unifying these three VMs. Then with
less ifdefs it would also not need hacks like this anymore.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
