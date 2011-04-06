Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab1DFUrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:47:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16179 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab1DFUrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=g0kRNjRE6sseIw6JVani5l/IPPn30WHD9/mQ4BcWWPOO5rJEkpp659wxS4Dz5ueZ3r
         OBIXqK/BOxwy8iK0ANTw==
MIME-Version: 1.0
In-Reply-To: <1302010101.2225.1334.camel@twins>
References: <20110323030326.789836913@google.com> <20110323030448.950261975@google.com>
 <1302010101.2225.1334.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 6 Apr 2011 13:47:02 -0700
Message-ID: <BANLkTi=qYgNpSRyE87MVCYCg=rAo=V3cHQ@mail.gmail.com>
Subject: Re: [patch 03/15] sched: accumulate per-cfs_rq cpu usage
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 6:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
>> +       min_amount = sched_cfs_bandwidth_slice() + (-cfs_rq->quota_remaining);
>
> funny way of writing that ;-)
>

This was intended to call out that quota_remaining is <= 0 at this
point -- making it a positive sum.   A comment would do this just as
well though.
