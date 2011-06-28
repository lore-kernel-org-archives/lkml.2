Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1F1Eon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 00:44:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3062 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab1F1Emn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 00:42:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=It9u97mbgsFcHfHnczcKFgM7wz6LLZgetvS3KoMjn+dvaoUGhLxgbX2YJDTLmgDkdC
         a8tZewamo/6d1alJcyzg==
MIME-Version: 1.0
In-Reply-To: <1308757658.1022.50.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071700.395400025@google.com>
 <1308757658.1022.50.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 27 Jun 2011 21:42:09 -0700
Message-ID: <CAPM31RK7O3Fk5nb+ApiOBjeN5texNodCNibAbLLLxbwXtaCoog@mail.gmail.com>
Subject: Re: [patch 07/16] sched: expire invalid runtime
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 8:47 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-21 at 00:16 -0700, Paul Turner wrote:
>
>> +     now = sched_clock_cpu(smp_processor_id());
>> +     cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
>
>> +     if ((s64)(rq->clock - cfs_rq->runtime_expires) < 0)
>
> Is there a good reason to mix these two (related) time sources?
>

It does make sense to remove the (current) aliasing dependency, will
use rq->clock for setting expiration.
