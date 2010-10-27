Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab0J0OY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:24:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50401 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab0J0OY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vypi+sSuAj4QKVDtzIZYCGc+QV+/kpZE/6wCyz/Ik9A/jqD/tA2KC/mV4ZKxeQIcrx
         IAOVb2oBfvnyHpIFYpbjiVv2p/ZQQM7yCJFwz198X/gbvRYtpSd8rSYgCCYLFq8Kbqub
         qtIF84IJkCq9iNC1kd4inmxcGVyiB03XpwPEw=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <4CC83067.5000009@kernel.org>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 16:24:21 +0200
Message-ID: <1288189461.2709.144.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 16:00 +0200, Tejun Heo a écrit :

> Heh, interesting table.  What does the same code say on 64bit?  Is it
> the same?
> 

Yes this is the same

32bit : # numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 1 3 5 7 9 11 13 15
node 0 size: 2047 MB
node 0 free: 144 MB
node 1 cpus: 0 2 4 6 8 10 12 14
node 1 size: 2038 MB
node 1 free: 197 MB
node distances:
node   0   1 
  0:  10  20 
  1:  20  10 


64bit : # numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 1 3 5 7 9 11 13 15
node 0 size: 2047 MB
node 0 free: 1868 MB
node 1 cpus: 0 2 4 6 8 10 12 14
node 1 size: 2038 MB
node 1 free: 1912 MB
node distances:
node   0   1 
  0:  10  20 
  1:  20  10 
# cat /proc/buddyinfo 
Node 0, zone      DMA      1      0      1      0      2      1      1      0      1      1      3 
Node 0, zone    DMA32    454    206     93     15      3      1      1      2      1      3    460 
Node 1, zone    DMA32      3     19     17      1      0      1      1      1      1      1    380 
Node 1, zone   Normal     89     67     15      6      0      2      2      0      0      3     95 


