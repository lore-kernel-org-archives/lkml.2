Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2BFT72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:59:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44857 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab2BFT71 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:59:27 -0500
MIME-Version: 1.0
In-Reply-To: <1328556210.2482.20.camel@laptop>
References: <1328187288-24395-1-git-send-email-eranian@google.com>
	<1328187288-24395-10-git-send-email-eranian@google.com>
	<1328556210.2482.20.camel@laptop>
Date: Mon, 6 Feb 2012 20:59:25 +0100
Message-ID: <CABPqkBT8a5cZCcCP7SDv2moCpv-DNy06xQ=kqtZQ=1a4YaHa_Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/18] perf: disable PERF_SAMPLE_BRANCH_* when not supported
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 8:23 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-02-02 at 13:54 +0100, Stephane Eranian wrote:
>> @@ -539,6 +539,10 @@ static int armpmu_event_init(struct perf_event *event)
>>         int err = 0;
>>         atomic_t *active_events = &armpmu->active_events;
>>
>> +       /* does not support taken branch sampling */
>> +       if (has_branch_smpl(event))
>> +               return -EOPNOTSUPP;
>> +
>>         if (armpmu->map_event(event) == -ENOENT)
>
> I'll make that has_branch_stack(), ok? :-)
>
Supposedly, I fixed that in v5. Is it not there?
If not, then something went wrong but go ahead, that's the right fix anyway.
