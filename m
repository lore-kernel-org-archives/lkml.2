Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1FQCoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:44:30 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:46239 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab1FQCo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 22:44:29 -0400
Date: Thu, 16 Jun 2011 22:44:25 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        linux-kernel@vger.kernel.org
Subject: Re: scheduler / perf stat question about CPU-migrations
Message-ID: <20110617024425.GE29725@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	linux-kernel@vger.kernel.org
References: <E1QXDpy-0007Wr-5V@tytso-glaptop>
 <20110616150347.GB23624@somewhere.redhat.com>
 <4DFA1D07.1050705@draigBrady.com>
 <20110616151836.GC23624@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616151836.GC23624@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 05:18:39PM +0200, Frederic Weisbecker wrote:
> The only solution is too set perf affinity itself:
> 
> 	schedtool -a 1 -e perf stat -- e2fsck -ft /dev/funarg/kbuild

Nope, that doesn't solve the problem:

# schedtool -a 1 -e perf stat -- e2fsck -ft /dev/funarg/kbuild
e2fsck 1.41.14 (22-Dec-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/funarg/kbuild: 223466/1638400 files (0.3% non-contiguous), 4915668/6553600 blocks
Memory used: 2600k/0k (1069k/1532k), time:  6.72/ 1.18/ 0.36
I/O read: 137MB, write: 1MB, rate: 20.38MB/s

 Performance counter stats for 'e2fsck -ft /dev/funarg/kbuild':

       1523.616797 task-clock                #    0.224 CPUs utilized          
              7227 context-switches          #    0.005 M/sec                  
               253 CPU-migrations            #    0.000 M/sec                  
              1936 page-faults               #    0.001 M/sec                  
        4176409631 cycles                    #    2.741 GHz                    
     <not counted> stalled-cycles-frontend 
     <not counted> stalled-cycles-backend  
        4828485353 instructions              #    1.16  insns per cycle        
         877742160 branches                  #  576.091 M/sec                  
           8017490 branch-misses             #    0.91% of all branches        

       6.798746204 seconds time elapsed

Note the 253 CPU migration....

							- Ted
