Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1CVHfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 03:35:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:52893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab1CVHfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 03:35:17 -0400
Date: Tue, 22 Mar 2011 08:35:14 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: real meaning of memory.usage_in_bytes
Message-ID: <20110322073514.GB12940@tiehlicka.suse.cz>
References: <20110318152532.GB18450@tiehlicka.suse.cz>
 <20110321093419.GA26047@tiehlicka.suse.cz>
 <AANLkTimkcYcZVifaq4pH4exkWUVNXpwXA=9oyeAn_EqR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimkcYcZVifaq4pH4exkWUVNXpwXA=9oyeAn_EqR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-03-11 10:22:41, Ying Han wrote:
[...]
> 
> Michal,
> 
> Can you help to post the test result after applying the patch?

The result of the LTP test is:
TEST 4: MEMORY CONTROLLER TESTING
RUNNING SETUP.....
WARN:/dev/memctl already exist..overwriting
Cleanup called
TEST STARTED: Please avoid using system while this test executes
memory usage from memory.usage_in_bytes= 62955520
memory usage from memory.stat= 62955520
TINFO   Memory Resource Controller: stat check test passes first run
Test continues to run the second step.
memory usage from memory.usage_in_bytes= 78643200
memory usage from memory.stat=78643200
TPASS   Memory Resource Controller: stat check test PASSED
Memory Resource Controller test executed successfully.
Cleanup called

The attached simple test case result is:
# mkdir /dev/memctl; mount -t cgroup -omemory cgroup /dev/memctl; cd /dev/memctl
# mkdir group_1; cd group_1; echo 100M > memory.limit_in_bytes
# cat memory.{usage_in_bytes,stat} 
0
cache 0
rss 0
[start the test case, add its pid to the group and let it fault in]

# cat memory.{usage_in_bytes,stat} 
4096
cache 0
rss 4096

[let it finish]
# cat memory.{usage_in_bytes,stat} 
0
cache 0
rss 0

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
