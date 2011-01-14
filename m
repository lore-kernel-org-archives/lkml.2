Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab1ANRel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:34:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568Ab1ANRee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:34:34 -0500
Message-ID: <4D30891B.9010104@redhat.com>
Date: Fri, 14 Jan 2011 12:34:19 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: Re: [RFC -v5 PATCH 0/4] directed yield for Pause Loop Exiting
References: <20110114030209.53765a0a@annuminas.surriel.com>
In-Reply-To: <20110114030209.53765a0a@annuminas.surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 03:02 AM, Rik van Riel wrote:

> Benchmark "results":
>
> Two 4-CPU KVM guests are pinned to the same 4 physical CPUs.

I just discovered that I had in fact pinned the 4-CPU KVM
guests to 4 HT threads across 2 cores, and the scheduler
has all kinds of special magic for dealing with HT siblings.

I am now rerunning the tests with the KVM guests bound to
cores 0,2,4,6 to see if that makes a difference.

-- 
All rights reversed
