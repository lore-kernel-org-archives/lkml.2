Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0KJOZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:25:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:53460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0KJOZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:25:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fQu/NKNTvg3tmFrRklg5aY3l5Sc5Otk2+UYBZdccb11L4lk9n1Dr9CAydV2Iw72ucY
         Qx0M1Sbxf/vxYzJseu0g==
MIME-Version: 1.0
In-Reply-To: <1289398207.2191.117.camel@laptop>
References: <1289339119.2191.92.camel@laptop>
	<AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
	<1289398207.2191.117.camel@laptop>
Date: Wed, 10 Nov 2010 15:24:57 +0100
Message-ID: <AANLkTik1PoO6hwMH05YL19km7zYH_C3d-OocNSp2UTUv@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 3:10 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-11-10 at 14:01 +0100, Stephane Eranian wrote:
>> Peter,
>
>> > 6
>>
>> And then, what do you do with 6?
>> I assume you have to pass it in the attr struct.
>
> perf_event_attr::type, as said in the initial changelog.
>
>> How do you plan on doing this while keeping what is already there?
>
> +       if (type < 0) {
> +               err = idr_get_new_above(&pmu_idr, pmu, PERF_TYPE_MAX, &type);
>
> and
>
> +       rcu_read_lock();
> +       pmu = idr_find(&pmu_idr, event->attr.type);
> +       rcu_read_unlock();
> +       if (pmu)
> +               goto unlock;
>
>
> So we start dynamic IDs at the top of the static range, and only do
> dynamic IDs for those that don't already have a static number.
>
>
Ok, should work fine.
