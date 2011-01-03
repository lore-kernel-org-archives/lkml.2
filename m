Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1ACRbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:31:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab1ACRbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:31:46 -0500
Message-ID: <4D22077A.80001@zytor.com>
Date: Mon, 03 Jan 2011 09:29:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel@vger.kernel.org,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: Loss of PAT-WC after resume on i5
References: <849307$b076ne@azsmga001.ch.intel.com> <4D21F2C1.30500@zytor.com> <1bdc18$j527vf@fmsmga002.fm.intel.com>
In-Reply-To: <1bdc18$j527vf@fmsmga002.fm.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 08:21 AM, Chris Wilson wrote:
> On Mon, 03 Jan 2011 08:01:05 -0800, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> Sounds like it.  It sounds based on your description that it's something
>> more fundamental than just the state of the PAT MSR being lost, too,
>> although perhaps that's the first thing to check...
> 
> Right, I should have mentioned that a rdmsr(MSR_ISA32_CR_PAT) showed no
> change across a dysfunctional resume. And that
> /sys/kernel/debug/x86/pat_memtype_list had the same contents (just the
> first entries reversed upon resume).

OK, this is doubly strange: both that entries would have change order
and that they would not be active, if the PAT MSR is set correctly.
That would imply that the page tables are somehow corrupt, which seems
like a scary concept.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

