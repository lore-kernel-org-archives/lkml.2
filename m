Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab2EYWtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:49:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:19368 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab2EYWtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:49:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="104453223"
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: perf, x86: only do lbr init if bts is available
References: <4FBE5FA6.5050802@gmail.com>
	<CABPqkBT7dKa3P2hk=_pismGdPHuseWMbCKhUzz1sQNDemb133A@mail.gmail.com>
	<4FBE64D0.7040507@gmail.com>
	<CABPqkBQc=XAfGY8_Rex4Hy91eBtwxtGzpfT0RaskBDDcSv1C4w@mail.gmail.com>
Date: Fri, 25 May 2012 15:49:04 -0700
In-Reply-To: <CABPqkBQc=XAfGY8_Rex4Hy91eBtwxtGzpfT0RaskBDDcSv1C4w@mail.gmail.com>
	(Stephane Eranian's message of "Thu, 24 May 2012 19:11:28 +0200")
Message-ID: <m2obpblvvj.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:

> On Thu, May 24, 2012 at 6:41 PM, David Ahern <dsahern@gmail.com> wrote:
>> On 5/24/12 10:35 AM, Stephane Eranian wrote:
>>>
>>> Well, no. There is no connection between BTS and LBR and you're creating
>>> one.
>>
>>
>> Ok. That was not clear to me from skimming the manual.
>> Then should it be tied to X86_FEATURE_DTES64?
>>
> No, it is unrelated to the Debug Store.
> There is really nothing you can use to figure that out, not event IA32_DEBUGCTL.

One way to do it would be to reread DEBUGCTL after writing and see if
the bit really changed to 1. If not assume LBR is not available.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
