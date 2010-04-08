Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0DHE7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:59:45 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65464 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0DHE7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c9TSv6XOu6xpvFJqQ4F0vAUoDcyMNwnFIeCspyVwjjuBzqY5+aFuFKn3bY7SxtWWyc
         bUbNKUNG9zh/Etd7IdXQGV77VUv3e9njwsgAoaconMPFnl2acAyiTFOJUVOlegE9OqZN
         T3QNKROGkHqcEwksPb2Z98yP9QK6DoXTfs0JI=
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev <netdev@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1270688747.2078.383.camel@ymzhang.sh.intel.com>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
	 <1270542497.2078.123.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004061033330.18750@router.home>
	 <alpine.DEB.2.00.1004061552500.19151@router.home>
	 <1270591841.2091.170.camel@edumazet-laptop>
	 <1270607668.2078.259.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004071130260.13261@router.home>
	 <4BBCB7B7.4040901@cs.helsinki.fi> <4BBCB868.2000705@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004071319320.16159@router.home>
	 <1270665484.8141.47.camel@edumazet-laptop>
	 <1270688747.2078.383.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 06:59:34 +0200
Message-ID: <1270702774.8141.49.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 avril 2010 à 09:05 +0800, Zhang, Yanmin a écrit :

> > Do we have a user program to check actual L1 cache size of a machine ?
> If there is no, it's easy to write it as kernel exports the cache stat by
> /sys/devices/system/cpu/cpuXXX/cache/indexXXX/

Yes, this is what advertizes my L1 cache having 64bytes lines, but I
would like to check that in practice, this is not 128bytes...

./index0/type:Data
./index0/level:1
./index0/coherency_line_size:64
./index0/physical_line_partition:1
./index0/ways_of_associativity:8
./index0/number_of_sets:64
./index0/size:32K
./index0/shared_cpu_map:00000101
./index0/shared_cpu_list:0,8
./index1/type:Instruction
./index1/level:1
./index1/coherency_line_size:64
./index1/physical_line_partition:1
./index1/ways_of_associativity:4
./index1/number_of_sets:128
./index1/size:32K
./index1/shared_cpu_map:00000101
./index1/shared_cpu_list:0,8


