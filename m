Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1CWUxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:53:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20353 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1CWUxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qE2K+/nfqVz3eDJv1lOHtGBHvDJWybrkIgP0FZ+oxfHHTvrSVAYQS4gjICRF78ODXX
         Dc8s9LVedHjlFgYryo5A==
MIME-Version: 1.0
In-Reply-To: <1300856976.7492.44.camel@marge.simson.net>
References: <20110323030326.789836913@google.com> <20110323030449.047028257@google.com>
 <1300856976.7492.44.camel@marge.simson.net>
From: Paul Turner <pjt@google.com>
Date: Wed, 23 Mar 2011 13:53:11 -0700
Message-ID: <AANLkTikCe3rMcYCn52cT3nZ_i-w+Fe1rGg8UaB2ayiVS@mail.gmail.com>
Subject: Re: [patch 04/15] sched: throttle cfs_rq entities which exceed their
 local quota
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:09 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
>
>> +static void check_cfs_rq_quota(struct cfs_rq *cfs_rq)
>> +{
>> +     if (within_bandwidth(cfs_rq))
>> +             return;
>> +
>> +
>
> Nit:  It'd be nice if classes agreed on naming convention to ease
> rummaging.  In rt, it's bandwidth for bean counting parameters, but the
> beans are runtime.  within_bandwidth() vs sched_rt_runtime_exceeded()
> kinda pokes me in the eye when I look at the total.  Seems to me it
> should be uniformly either quota or bandwidth, and uniformly runtime.
>

True enough, I'll rename to bring these more in-line with their RT equivalents

>        -Mike
>
>
>
