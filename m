Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1ERHDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:03:07 -0400
Received: from smtp-out.google.com ([74.125.121.67]:17821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1ERHDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fGI3CmcuwULdAqPfx/Q//wuyp4vnl63/BmHHrNz7H+uMPp2xYy+wZD9TffQpmvzLe3
         OT9TjXUv5d/Y1IQoDQyQ==
MIME-Version: 1.0
In-Reply-To: <1305646122.2466.5894.camel@twins>
References: <20110503092846.022272244@google.com> <20110503092904.985285812@google.com>
 <1305541621.2466.4112.camel@twins> <BANLkTin_0v7q1xDwwnOpo6ZFMbDNARisGg@mail.gmail.com>
 <1305646122.2466.5894.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 18 May 2011 00:02:31 -0700
Message-ID: <BANLkTimthZFHbb0R7sgoHAKTkH6s4w0KHA@mail.gmail.com>
Subject: Re: [patch 06/15] sched: accumulate per-cfs_rq cpu usage and charge
 against bandwidth
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 8:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-05-16 at 05:59 -0700, Paul Turner wrote:
>> On Mon, May 16, 2011 at 3:27 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
>> >> +unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
>> >
>> > What happens when the period is smaller than the slice?
>> >
>>
>> We'll always take at most whatever's left in this case.
>
> Right, saw that, but it might be good to have a little comment
> explaining the interaction between the slice and the period things.
>

Oh, sure -- easy enough :)
