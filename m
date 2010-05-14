Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0ENQgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:36:50 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54625 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab0ENQgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VA3fpaa19LoJqGOnMZ3WL4i6O0HZWZ++4FYvljgHXxni7zJKsrchCQrC9dIw2O/xav
         NmDXNcoFKexF+NvlBXkHhkKaHRnm/zfu2dFUB1WX0h1wMZniioszXXMG8/r5/ylzSekf
         qZF6dHMft+GOj/qlrHt+xTc3cNNDh+3x4TMHs=
MIME-Version: 1.0
In-Reply-To: <20100514162813.GB13509@lenovo>
References: <AANLkTinbrhuGqHss_aML3EAccOq792GUZtqzzjQqzG6I@mail.gmail.com>
	 <AANLkTimrHGq1kZwPev7gBZu6Hqxlhe0ZscSKjEinZtcf@mail.gmail.com>
	 <AANLkTik-gIjZu60pFWEhhe8MolQITrtk0wfpvSUCLnrD@mail.gmail.com>
	 <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
	 <1273834571.3530.82.camel@minggr.sh.intel.com>
	 <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo>
	 <20100514145213.GA13509@lenovo>
	 <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com>
	 <20100514162813.GB13509@lenovo>
Date: Fri, 14 May 2010 22:06:44 +0530
Message-ID: <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cyrill,

On Fri, May 14, 2010 at 9:58 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, May 14, 2010 at 09:52:28PM +0530, Jaswinder Singh Rajput wrote:
> ...
>> Yes, this works for me. Now I am not getting general protection fault.
>>
>> It seems hardware events are not supported for P4 yet.
>>
>> $ ./perf stat -e
>> cycles,instructions,cache-references,cache-misses,branches,branch-misses,bus-cycles
>> ls > /dev/null
>>
>>  Performance counter stats for 'ls':
>>
>>   <not counted>  cycles
>>          601636  instructions             #      0.000 IPC    (scaled
>> from 91.80%)
>>   <not counted>  cache-references
>>   <not counted>  cache-misses
>>   <not counted>  branches
>>   <not counted>  branch-misses
>>   <not counted>  bus-cycles
>>
>>     0.003364910  seconds time elapsed
>
> Thanks Jaswinder,
>
> it means counters management somehow screwed at moment (it was working before).
> I'm working on it.
>

Ok, I added few more events and now I am able see few hardware events :

$ ./perf stat -e
cycles,instructions,cache-references,cache-misses,branches,branch-misses,bus-cycles,L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-dcache-store-misses,L1-dcache-prefetches,L1-dcache-prefetch-misses,L1-icache-loads,L1-icache-load-misses,L1-icache-prefetches,L1-icache-prefetch-misses,LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,LLC-prefetches,LLC-prefetch-misses,dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses,dTLB-prefetches,dTLB-prefetch-misses,iTLB-loads,iTLB-load-misses
ls -lR /dev > /dev/null

 Performance counter stats for 'ls -lR /dev':

  <not counted>  cycles
       10159428  instructions             #      0.000 IPC    (scaled
from 11.71%)
  <not counted>  cache-references
  <not counted>  cache-misses
        2160905  branches                  (scaled from 9.71%)
          80630  branch-misses            #      3.731 %      (scaled
from 15.68%)
  <not counted>  bus-cycles
  <not counted>  L1-dcache-loads
          90289  L1-dcache-load-misses     (scaled from 14.23%)
  <not counted>  L1-dcache-stores
  <not counted>  L1-dcache-store-misses
  <not counted>  L1-dcache-prefetches
  <not counted>  L1-dcache-prefetch-misses
  <not counted>  L1-icache-loads
  <not counted>  L1-icache-load-misses
  <not counted>  L1-icache-prefetches
  <not counted>  L1-icache-prefetch-misses
  <not counted>  LLC-loads
           3162  LLC-load-misses           (scaled from 12.40%)
  <not counted>  LLC-stores
  <not counted>  LLC-store-misses
  <not counted>  LLC-prefetches
  <not counted>  LLC-prefetch-misses
  <not counted>  dTLB-loads
          21825  dTLB-load-misses          (scaled from 11.04%)
  <not counted>  dTLB-stores
           1386  dTLB-store-misses         (scaled from 9.96%)
  <not counted>  dTLB-prefetches
  <not counted>  dTLB-prefetch-misses
  <not counted>  iTLB-loads
  <not counted>  iTLB-load-misses

    0.019403422  seconds time elapsed


Thanks, good work :-)

--
Jaswinder Singh.
