Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab0CRV5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:57:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab0CRV5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:57:34 -0400
Message-ID: <4BA2A1CD.1070207@redhat.com>
Date: Thu, 18 Mar 2010 17:57:33 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics fromhost
 side
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@xxxxxxxx> wrote:

> * Avi Kivity <avi@xxxxxxxxxx> wrote:
> 
> > Monitoring guests from the host is useful for kvm developers, but less so
> > for users.
> 
> Guest space profiling is easy, and 'perf kvm' is not about that. (plain 'perf'
> will work if a proper paravirt channel is opened to the host)
> 
> I think you might have misunderstood the purpose and role of the 'perf kvm'
> patch here? 'perf kvm' is aimed at KVM developers: it is them who improve KVM
> code, not guest kernel users.
> 
> Ingo

The software performance events work fine in a KVM guest. Do the hardware performance events work in KVM guest  environment? Last time I looked the results for the hardware counters were not sane. The values were seemingly random numbers. Something like the following.

Performance counter stats for 'ls':

       3.427434  task-clock-msecs         #      0.046 CPUs 
              2  context-switches         #      0.001 M/sec
              0  CPU-migrations           #      0.000 M/sec
            218  page-faults              #      0.064 M/sec
 140737488355327  cycles                   # 41062056440.861 M/sec
 68825777242116  instructions             #      0.489 IPC  
 68825777242117  branches                 # 20080846849.893 M/sec
 68825777242118  branch-misses            #    100.000 %    
  <not counted>  cache-references        
  <not counted>  cache-misses     

The guest image is using 2.6.34-0.10.rc1.git0.fc14.it68 kernel and the host is Fedora-12 with a kernel built from 2.6.34-rc1-tip+ git tree running on Quad-Core AMD Opteron(tm) Processor 2350. Is there some combination of kernel/distribution/hardware that the hardware performance counters are suppose to work on?

-Will
