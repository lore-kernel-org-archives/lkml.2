Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1EKQ1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:27:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58809 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348Ab1EKQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ZsvjOLIo3cEoffItS3FoxvzJOXPJ3ORCuWPLMWq7TBbmaHNUWpWLi/GO3DAzCdm3R3
         SjCHu+FRmZMOJe6G9gdC7qLqRswhZX7dFei/DPkm4q8xEoTC4rHFAq+pujVfFRTv4YgH
         hYnz3HIJyS3bDCM2NpEAu4l2xs/4bFFfU17b8=
Message-ID: <4DCAB8A2.8060605@linux.com>
Date: Wed, 11 May 2011 18:26:10 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: lock_stat &rq->lock/1 class name meaning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm trying to collect contention statistics through /proc/lock_stat 
about scheduler data structures.

What I obtain if a do "cat /proc/lock_stat" is something like:
...
&rq->lock:         13128          13128           0.43         190.53 
    103881.26          97454        3453404           0.00 
401.11    13224683.11
---------
&rq->lock            645          [<ffffffff8103bfc4>] 
task_rq_lock+0x43/0x75
&rq->lock            297          [<ffffffff8104ba65>] 
try_to_wake_up+0x127/0x25a
&rq->lock            360          [<ffffffff8103c4c5>] 
select_task_rq_fair+0x1f0/0x74a
&rq->lock            428          [<ffffffff81045f98>] 
scheduler_tick+0x46/0x1fb
---------
&rq->lock             77          [<ffffffff8103bfc4>] 
task_rq_lock+0x43/0x75
&rq->lock            174          [<ffffffff8104ba65>] 
try_to_wake_up+0x127/0x25a
&rq->lock           4715          [<ffffffff8103ed4b>] 
double_rq_lock+0x42/0x54
&rq->lock            893          [<ffffffff81340524>] schedule+0x157/0x7b8
.
.
.
...
&rq->lock/1:         11526          11488           0.33         388.73 
      136294.31          21461          38404           0.00 
37.93      109388.53
-----------
&rq->lock/1          11526          [<ffffffff8103ed58>] 
double_rq_lock+0x4f/0x54
-----------
&rq->lock/1           5645          [<ffffffff8103ed4b>] 
double_rq_lock+0x42/0x54
&rq->lock/1           1224          [<ffffffff81340524>] 
schedule+0x157/0x7b8
&rq->lock/1           4336          [<ffffffff8103ed58>] 
double_rq_lock+0x4f/0x54
&rq->lock/1            181          [<ffffffff8104ba65>] 
try_to_wake_up+0x127/0x25a

I guess the first one is about the per-rq (per-CPU) spinlock, but what 
about the second? What the "/1" stands for?
Since every rq has a different spinlock, does &rq->lock group numbers 
from all the runqueues?

Thanks a lot,
	Juri
