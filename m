Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab1AMFJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:09:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912Ab1AMFJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:09:20 -0500
Message-ID: <4D2E88EA.3050604@redhat.com>
Date: Thu, 13 Jan 2011 00:08:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110103162637.29f23c40@annuminas.surriel.com>	 <20110103162918.577a9620@annuminas.surriel.com>	 <1294164289.2016.186.camel@laptop>	 <1294246647.8369.52.camel@marge.simson.net>	 <1294247065.2016.267.camel@laptop>	 <1294378146.8823.27.camel@marge.simson.net>  <4D2E6B62.2000802@redhat.com> <1294889169.8089.10.camel@marge.simson.net>
In-Reply-To: <1294889169.8089.10.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 10:26 PM, Mike Galbraith wrote:
> On Wed, 2011-01-12 at 22:02 -0500, Rik van Riel wrote:
>
>> Cgroups only makes the matter worse - libvirt places
>> each KVM guest into its own cgroup, so a VCPU will
>> generally always be alone on its own per-cgroup, per-cpu
>> runqueue!  That can lead to pulling a VCPU onto our local
>> CPU because we think we are alone, when in reality we
>> share the CPU with others...
>
> How can that happen?  If the task you're trying to accelerate isn't in
> your task group, the whole attempt should be a noop.

Nono, all the VCPUs from the same guest are in the same
cgroup.  However, with 4 VCPUs and 4 physical CPUs,
chances are that they're all alone on their own per-cpu,
per-cgroup cfs_rq.

However, each CPU might have other runnable processes in
other cfs_rq sched entities.

-- 
All rights reversed
