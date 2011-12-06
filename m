Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1LFT1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:27:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1LFT1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:27:52 -0500
MIME-Version: 1.0
In-Reply-To: <1323123260.32012.44.camel@twins>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	<1318595833-29984-2-git-send-email-eranian@google.com>
	<1323123260.32012.44.camel@twins>
Date: Tue, 6 Dec 2011 11:27:51 -0800
Message-ID: <CABPqkBT2RVHiebJF=b=bt95tGrEL-S0_h6yQOo+Ric368_1Kug@mail.gmail.com>
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling
 support (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 2:14 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
>> +#define PERF_SAMPLE_BRANCH_PLM_ALL \
>> +       (PERF_SAMPLE_BRANCH_USER|\
>> +        PERF_SAMPLE_BRANCH_KERNEL)
>
> This PLM thing keeps popping up all over, I'm sure it stands for
> something, but for now it just hurts my eyes.
>
>
>> +               /* at least one branch bit must be set */
>> +               if (!(mask & ~PERF_SAMPLE_BRANCH_PLM_ALL))
>> +                       return -EINVAL;
>>
> Why? we can create counters with exclude_user && exclude_kernel as well,
> I mean, they're useless, but its perfectly valid.


I am fine with that change. I can drop this check.
