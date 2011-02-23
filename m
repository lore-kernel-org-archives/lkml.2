Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1BWIEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:04:16 -0500
Received: from smtp-out.google.com ([74.125.121.67]:1599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1BWIEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ygGAKGv7HYMvOCoFUJ6XavOdYDTPa8DLLk49j1Lmsln/YWbQN5mRCdj6V40RA+iJX1
         t7pqG3scJXZlPal8dFtA==
MIME-Version: 1.0
In-Reply-To: <20110222044035.GL10342@balbir.in.ibm.com>
References: <20110216031831.571628191@google.com> <20110216031841.258879435@google.com>
 <20110222031420.GI10342@balbir.in.ibm.com> <20110222041332.GA2753@in.ibm.com> <20110222044035.GL10342@balbir.in.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 23 Feb 2011 00:03:42 -0800
Message-ID: <AANLkTinsxWgRAV5JvAnX5B7nXFWp9sE7y41gHJtkwg=6@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 5/7] sched: add exports tracking cfs
 bandwidth control statistics
To: balbir@linux.vnet.ibm.com
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 8:40 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * Bharata B Rao <bharata@linux.vnet.ibm.com> [2011-02-22 09:43:33]:
>
>> >
>> > Should we consider integrating this in cpuacct, it would be difficult
>> > if we spill over stats between controllers.
>>
>> Given that cpuacct controller can be mounted independently, I am not sure
>> if we should integrate these stats. These stats come from cpu controller.
>
> The accounting controller was created to account. I'd still prefer
> cpuacct, so that I can find everything in one place. NOTE: cpuacct was
> created so that we do accounting with control - just account. I think
> splitting stats creates a usability mess - no?
>

One problem with rolling it into cpuacct is that some of the
statistics have a 1:1 association with the hierarchy being throttled.
For example, the number of periods in which throttling occurred or the
count of elapsed periods.

If it were rolled into cpuacct the only meaningful export would be the
total throttled time -- perhaps this is sufficient?

> --
>        Three Cheers,
>        Balbir
>
