Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab1EKQNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:13:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab1EKQNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:13:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l5nUqnTvlJRQQsDIMNsJdaYuZD60jw0sCbpIdLmKXX5ScDic9v/j+R6UqvdMEa7LCw
         mKFe2PDsgWW0XDfBsKlQ==
MIME-Version: 1.0
In-Reply-To: <4DC8E8BA.3010106@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110503092905.427302001@google.com>
 <4DC8E8BA.3010106@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 May 2011 02:11:42 -0700
Message-ID: <BANLkTi=hDfFMGZfEfOkHAT1ixcYyMcq+xw@mail.gmail.com>
Subject: Re: [patch 11/15] sched: prevent interactions between throttled
 entities and load-balance
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

On Tue, May 10, 2011 at 12:26 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/05/03 18:28), Paul Turner wrote:
>>>From the perspective of load-balance and shares distribution, throttled
>> entities should be invisible.
>>
>> However, both of these operations work on 'active' lists and are not
>> inherently aware of what group hierarchies may be present.  In some cases this
>> may be side-stepped (e.g. we could sideload via tg_load_down in load balance)
>> while in others (e.g. update_shares()) it is more difficult to compute without
>> incurring some O(n^2) costs.
>>
>> Instead, track hierarchal throttled state at time of transition.  This allows
>
>                 hierarchical

Fixed, Thanks

>
>> us to easily identify whether an entity belongs to a throttled hierarchy and
>> avoid incorrect interactions with it.
>>
>> Also, when an entity leaves a throttled hierarchy we need to advance its
>> time averaging for shares averaging so that the elapsed throttled time is not
>> considered as part of the cfs_rq's operation.
>>
>> Signed-off-by: Paul Turner <pjt@google.com>
>> ---
>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
> Thanks,
> H.Seto
>
>
