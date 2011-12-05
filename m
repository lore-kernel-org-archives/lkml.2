Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1LEVik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:38:40 -0500
Received: from lo.gmane.org ([80.91.229.12]:32776 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756449Ab1LEVii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:38:38 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Laurence Oberman <laurence.oberman@hp.com>
Subject: Re: Regression in reading /proc/stat in the newer kernels with large SMP and NUMA configurations
Date: Mon, 5 Dec 2011 21:38:18 +0000 (UTC)
Message-ID: <loom.20111205T223639-642@post.gmane.org>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>  <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E29DD4@GVW1119EXC.americas.hpqcorp.net>  <1318600023.2223.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <8DC664164FA4D1449479E7B36CDCFB1F221F060A48@GVW0676EXC.americas.hpqcorp.net>  <1318610416.2223.45.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <8DC664164FA4D1449479E7B36CDCFB1F221F060A92@GVW0676EXC.americas.hpqcorp.net>  <1318611542.2223.47.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <8DC664164FA4D1449479E7B36CDCFB1F221F060AC2@GVW0676EXC.americas.hpqcorp.net>  <9FCE3A46FE7C8045A6207AE4B42E9F9A4EC2E2A848@GVW1119EXC.americas.hpqcorp.net> <1318879445.2571.20.camel@edumazet-laptop> <loom.20111205T221311-142@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 15.219.153.75 (Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20100101 Firefox/8.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurence Oberman <laurence.oberman <at> hp.com> writes:

> 
> 
> Eric Dumazet <eric.dumazet <at> gmail.com> writes:
> 
> Hi Eric,
> 
> I finally managed to get some time to test the patch. I am testing on the
> generic kernel.org 2.6.39 tree and will update you as soon as possible.
> 
> Thanks
> Laurence
> 
> 

Hello,
Results are in, patch makes a huge difference:

We are now getting results in the usecs again.


[root@o184i026 lobe]# strace -c ./t
Opened, read and closed 8640 times and read total of 69819840 bytes
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 99.86    0.964056         112      8641           read
  0.08    0.000786           0      8642           open
  0.06    0.000554           0      8642           close
  0.00    0.000034           4         8           mmap
  0.00    0.000000           0         1           write
  0.00    0.000000           0         3           fstat
  0.00    0.000000           0         3           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         1           brk
  0.00    0.000000           0         1           ioctl
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.965430                 25946         1 total  

What do you need me to do to get your patch accepted.

Thanks
Laurence


