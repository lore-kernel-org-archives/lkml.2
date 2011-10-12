Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1JLUhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:37:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1JLUhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:37:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:content-transfer-encoding;
	b=jGYgzk3draI8O8/ObKTD0Qhn8u+Z/qiqLBA6mzoDQBCCq7uHTKleyJrEGEAjLiAWW
	3vpkvxe/av0GHPXq7Rtpg==
MIME-Version: 1.0
In-Reply-To: <20111012165154.GB6158@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
	<20111010233842.GC24583@mgebm.net>
	<1318319095.14400.54.camel@laptop>
	<20111012165154.GB6158@mgebm.net>
Date: Wed, 12 Oct 2011 22:37:36 +0200
Message-ID: <CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
Subject: Re: Oprofile Regression Caused by commit e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25
 on PPC
From: Stephane Eranian <eranian@google.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could be:
   a8d757e perf events: Fix slow and broken cgroup context switch code


On Wed, Oct 12, 2011 at 6:51 PM, Eric B Munson <emunson@mgebm.net> wrote:
> On Tue, 11 Oct 2011, Peter Zijlstra wrote:
>
>> On Mon, 2011-10-10 at 19:38 -0400, Eric B Munson wrote:
>> > On Fri, 07 Oct 2011, Eric B Munson wrote:
>> >
>> > > This commit seems to have caused a regression with oprofile.  It is fairly easy
>> > > to trigger, simply run oprofile monitoring an event that will fire (something
>> > > frequent like CPU cycles) causes oprofile to fail saying that the PMU is in use.
>> > > If I disable CONFIG_CGROUP_PERF, everything goes back to working.  I suspect the
>> > > problem is that the PMU is being initialized without being reserved for perf.  I
>> > > am not yet sure of the right fix yet so if you have any suggestions I would
>> > > appreciate them.
>> > >
>> > > Eric
>> >
>> > This isn't the best description of the behavior we see, what happens is at some
>> > point in the profiling session the MMCR register is clobbered by
>> > perf_cgroup_switch() which calls perf_pmu_enable() without reserving the PMC
>> > hardware.  When this happens oprofile stops counting.  It doesn't happen each
>> > time so some runs show event counts that are reasonable, but it can also lead to
>> > event counts that are smaller than expected, or completely missing.
>>
>> What kernel are you testing?
>>
>
> The problem seems to be fixed in 3.1-rc9 so I just need to identify the
> patch(es) that fixed it.
>
> Eric
>
