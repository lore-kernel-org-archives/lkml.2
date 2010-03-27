Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0C0CJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 22:09:32 -0400
Received: from mailhub129.itcs.purdue.edu ([128.210.5.129]:51121 "EHLO
	mailhub129.itcs.purdue.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072Ab0C0CJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 22:09:31 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 22:09:31 EDT
Message-ID: <4BAD675E.3050600@purdue.edu>
Date: Fri, 26 Mar 2010 22:03:10 -0400
From: Naresh Rapolu <nrapolu@purdue.edu>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Hardware performance events are not counted by  "perf"   in a 2.6.31.12
  KVM guest
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.5.7.378829
X-PerlMx-Virus-Scanned: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

"perf"  tool does not count  hardware performance events ( cache misses 
etc) in a  KVM guest ( Ubuntu 9.10 karmic,  2.6.31-14-generic  kernel) 
on  Xeon 5530 quad-core.  The host  is  2.6.28  kernel , Ubuntu 8.04 
LTS, Hardy.

readfile.sh  reads in a  large file (1430 lines),  which should cause  
cache-misses.
root@multicore4-vm3:/usr/src/linux-2.6.31.12/tools/perf# ./perf stat -r 
5 -- bash readfile.sh

Performance counter stats for 'bash readfile.sh' (5 runs):

  11002.207467  task-clock-msecs         #      1.042 CPUs    ( +-  
10.834% )
          3480  context-switches                 #      0.000 M/sec   ( 
+-  19.017% )
          2238  CPU-migrations                 #      0.000 M/sec   ( 
+-  29.488% )
        482299  page-faults                      #      0.044 M/sec   ( 
+-   0.141% )
             0  cycles                                  #      0.000 
M/sec   ( +-     nan% )
             0  instructions                          #        nan 
IPC     ( +-     nan% )
             0  cache-references                 #      0.000 M/sec   ( 
+-     nan% )
             0  cache-misses                      #      0.000 M/sec   ( 
+-     nan% )

  10.560510393  seconds time elapsed   ( +-  11.401% )

Do I need to make some configuration changes to enable hardware events 
?  A similar question was posted recently here : 
http://lkml.org/lkml/2010/3/18/342   but no response !
Any help would be greatly appreciated.

Thanks,
Naresh Rapolu.
