Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab1E0TeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:34:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39876 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1E0Td4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UBJhZxVQCGJW1hU0hcMCwdmWSQwK0tSTfsWvSKDdgreM5M4+Bo/Ia9ELlVOZx/TrWh
         31mzHIcrqUqStW+/gX07Sb64bGjCV+llBfyFLjzqWgYrH5d88r6bZ1X/LyUsj4dbWzn+
         GAxyAU/rnpgEpo2G5qm8EWuefA4gkI6asJBP0=
Message-ID: <4DDFFCA2.8030100@gmail.com>
Date: Fri, 27 May 2011 13:33:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: perf, H/W counters - ESX hosted VM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Has anyone successfully used perf within an ESX VM? dmesg shows a PMU is
discovered:

dmesg | grep -i performance
Performance Events: Nehalem/Corei7 events, Intel PMU driver.

yet data from it is nonsensical:

perf stat -v -- /tmp/a

task-clock-msecs: 20593318 20593318 20593318
context-switches: 2 20593318 20593318
CPU-migrations: 0 20593318 20593318
page-faults: 387 20593318 20593318
cycles: 10737418235 20593318 20593318
instructions: 10737418235 20593318 20593318
cache-references: 10737418235 20593318 20593318
cache-misses: 10737418235 20593318 20593318

 Performance counter stats for '/tmp/a':

      20.593318  task-clock-msecs         #      0.988 CPUs
              2  context-switches         #      0.000 M/sec
              0  CPU-migrations           #      0.000 M/sec
            387  page-faults              #      0.019 M/sec
    10737418235  cycles                   # 521403.022 M/sec
    10737418235  instructions             #      1.000 IPC
    10737418235  cache-references         # 521403.022 M/sec
    10737418235  cache-misses             # 521403.022 M/sec

    0.020837863  seconds time elapsed

David

/tmp/a  -- a step above 'sleep 1'

#!/bin/sh

declare -i i=0;
declare -i sum=0;
while [ $i -lt 1000 ]
do
	sum=$((sum + i))
    i=$((i+1))
done
echo "sum $sum"
