Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1EPM75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:59:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27381 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab1EPM74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OeHupXo8AVmHgY6OrB+mN8dX0z6+CarLQq/fKC7Ed9GprDcwdqSlqjnKB/UvZqwrfj
         mrQgqrcrv39M25kPV8+Q==
MIME-Version: 1.0
In-Reply-To: <1305541621.2466.4112.camel@twins>
References: <20110503092846.022272244@google.com> <20110503092904.985285812@google.com>
 <1305541621.2466.4112.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Mon, 16 May 2011 05:59:24 -0700
Message-ID: <BANLkTin_0v7q1xDwwnOpo6ZFMbDNARisGg@mail.gmail.com>
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

On Mon, May 16, 2011 at 3:27 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
>> +unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
>
> What happens when the period is smaller than the slice?
>

We'll always take at most whatever's left in this case.
