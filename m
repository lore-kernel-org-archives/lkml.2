Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab1D1Sd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:33:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11800 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1D1Sdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=STqqp0bCOK5DG84bU8qQ/DCcrqegNxtjuI7qwFAiE/ZjTiyO3/xMqzzzpA9jQYOkak
         idyu5m9yNtL04THntIMA==
MIME-Version: 1.0
In-Reply-To: <20110428121244.GA26851@linux.vnet.ibm.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
 <m3tydi6ehc.fsf@IBM-009124035060.in.ibm.com> <m3wriey4tw.fsf@IBM-009124035060.in.ibm.com>
 <20110428121244.GA26851@linux.vnet.ibm.com>
From: Nikhil Rao <ncrao@google.com>
Date: Thu, 28 Apr 2011 11:33:31 -0700
Message-ID: <BANLkTimKUSGU_8YzBMQcf2tH4tJ7-o6eBg@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
To: vatsa@linux.vnet.ibm.com
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 5:12 AM, Srivatsa Vaddagiri
<vatsa@linux.vnet.ibm.com> wrote:
> On Thu, Apr 28, 2011 at 05:18:27PM +0530, Nikunj A. Dadhania wrote:
>> --- kernel/sched.c.orig       2011-04-28 16:34:24.000000000 +0530
>> +++ kernel/sched.c    2011-04-28 16:36:29.000000000 +0530
>> @@ -1336,7 +1336,7 @@ calc_delta_mine(unsigned long delta_exec
>>                       lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
>>       }
>>
>> -     tmp = (u64)delta_exec * weight;
>> +     tmp = (u64)delta_exec * (weight >> SCHED_LOAD_RESOLUTION);
>
> Should we be fixing inv_weight rather to account for SCHED_LOAD_RESOLUTION here?
>

Yes, I have been looking into fixing inv_weight and calc_delta_mine()
calculations based on the assumption that we have u64 weights. IMO the
function is complicated because the return value needs to be
calculated to fit into unsigned long. I would like to update users of
calc_delta_mine() to use u64 instead of unsigned longs and I think
this can be easily done (quick inspection of the code shows two call
sites that need to be updated - update_curr() and wakeup_gran()).
Without the restriction to fit into unsigned long, I think we can make
calc_delta_mine() and the inv_weight calculations simpler.

-Thanks,
Nikhil
