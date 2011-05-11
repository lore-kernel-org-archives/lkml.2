Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab1EKQaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:30:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51621 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab1EKQaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YjQOZhO6QHItgoswfCU3xRYvjt3l32Go9v0pNzzmuTIs0LVWVPLnPnD7T0QDkMOMfe
         ukTPgYYNqoUdFox19E8A==
MIME-Version: 1.0
In-Reply-To: <4DC8E780.6020306@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110503092904.895444153@google.com>
 <4DC8E780.6020306@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 May 2011 02:27:34 -0700
Message-ID: <BANLkTimGFRS8KOf+bx8_0P0jMkRAZXW6Dg@mail.gmail.com>
Subject: Re: [patch 05/15] sched: add a timer to handle CFS bandwidth refresh
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:21 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/05/03 18:28), Paul Turner wrote:
>> @@ -250,6 +253,9 @@ struct cfs_bandwidth {
>>       ktime_t period;
>>       u64 quota;
>>       s64 hierarchal_quota;
>> +
>> +     int idle;
>> +     struct hrtimer period_timer;
>>  #endif
>>  };
>>
>
> "idle" is not used yet.  How about adding it in later patch?
> Plus, comment explaining how it is used would be appreciated.

Fixed both.  (idle belongs to the accumulate patch)

>
>>  static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>>  {
>>       raw_spin_lock_init(&cfs_b->lock);
>>       cfs_b->quota = RUNTIME_INF;
>>       cfs_b->period = ns_to_ktime(default_cfs_period());
>> +
>> +     hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>> +     cfs_b->period_timer.function = sched_cfs_period_timer;
>> +
>>  }
>
> Nit: blank line?
>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
>
> Thanks,
> H.Seto
>
>
