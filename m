Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab1JaTBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:01:09 -0400
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:54253 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab1JaTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:01:08 -0400
Message-ID: <4EAEF004.8070005@genband.com>
Date: Mon, 31 Oct 2011 12:59:16 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17> <20111030212644.GA7106@khazad-dum.debian.net>
In-Reply-To: <20111030212644.GA7106@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2011 18:59:18.0389 (UTC) FILETIME=[31256250:01CC97FF]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18484.001
X-TM-AS-Result: No--17.871700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2011 03:26 PM, Henrique de Moraes Holschuh wrote:
> On Sun, 30 Oct 2011, Artem S. Tashkinov wrote:
>> I've found out that even on Linux 3.0.8 the process scheduler doesn't correctly distributes
>> the load amongst virtual CPUs. E.g. on a 4-core system (8 total virtual CPUs) the process
>> scheduler often run some instances of four different tasks on the same physical CPU.
>
> Please check how your sched_mc_power_savings and sched_smt_power_savings
> tunables.   Here's the doc from lesswats.org:
>
> 'sched_mc_power_savings' tunable under /sys/devices/system/cpu/ controls
> the Multi-core related tunable. By default, this is set to '0' (for
> optimal performance). By setting this to '1', under light load
> scenarios, the process load is distributed such that all the cores in a
> processor package are busy before distributing the process load to other
> processor packages.
>
> [...]
>
> 'sched_smt_power_savings' tunable under /sys/devices/system/cpu/
> controls the multi-threading related tunable. By default, this is set to
> '0' (for optimal performance). By setting this to '1', under light load
> scenarios, the process load is distributed such that all the threads in
> a core and all the cores in a processor package are busy before
> distributing the process load to threads and cores, in other processor
> packages.


I'm currently running Fedora 14 (2.6.35.14-97.fc14.x86_64 kernel) on an 
i5 560M cpu.  It's supposed to have 2 cores, with hyperthreading.

I created a tiny cpu burner program that just busy-loops.  Running two 
instances on my system they were always scheduled on separate physical 
cpus regardless of the values in sched_mc_power_savings or 
sched_smt_power_savings.

Running four instances they were always spread across all four "cpus".

With the newer 8-core chips (plus HT) in multi-socket boards with 
package-level turbo-boost and NUMA memory access this is going to get 
really interesting...

Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
