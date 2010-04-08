Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab0DHPw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:52:26 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63288 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab0DHPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YKIzpg6OWx0jCargyhcQYFJrU4d+7IttECgF5luS790+vwgNgDPSs5oXPeiZzbXaaf
         Ny3xcFyNaKDdm6Babi+OWX5OKbY3lcb3Gsr6KKWtC+ezJqSeaYF6TtyvMdYia3RpylP9
         YXgVXJK82YVG7s4TYcDoGnhiMAQAYrjvblcRo=
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev <netdev@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1004081033420.6321@router.home>
References: <1270705153.8141.58.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1004081033420.6321@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 17:52:19 +0200
Message-ID: <1270741939.2215.68.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 avril 2010 à 10:34 -0500, Christoph Lameter a écrit :
> On Thu, 8 Apr 2010, Eric Dumazet wrote:
> 
> > I suspect NUMA is completely out of order on current kernel, or my
> > Nehalem machine NUMA support is a joke
> >
> > # numactl --hardware
> > available: 2 nodes (0-1)
> > node 0 size: 3071 MB
> > node 0 free: 2637 MB
> > node 1 size: 3062 MB
> > node 1 free: 2909 MB
> 
> How do the cpus map to the nodes? cpu 0 and 1 both on the same node?

one socket maps to 0 2 4 6 8 10 12 14 (Node 0)
one socket maps to 1 3 5 7 9 11 13 15 (Node 1)

# numactl --cpubind=0 --membind=0 numactl --show
policy: bind
preferred node: 0
interleavemask: 
interleavenode: 0
nodebind: 0 
membind: 0 
cpubind: 1 3 5 7 9 11 13 15 1024 

(strange 1024 report...)

# numactl --cpubind=1 --membind=1 numactl --show
policy: bind
preferred node: 1
interleavemask: 
interleavenode: 0
nodebind: 
membind: 1 
cpubind: 0 2 4 6 8 10 12 14 



[    0.161170] Booting Node   0, Processors  #1
[    0.248995] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.269177]  Ok.
[    0.269453] Booting Node   1, Processors  #2
[    0.356965] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.377207]  Ok.
[    0.377485] Booting Node   0, Processors  #3
[    0.464935] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.485065]  Ok.
[    0.485217] Booting Node   1, Processors  #4
[    0.572906] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.593044]  Ok.
...
grep "physical id" /proc/cpuinfo 
physical id	: 1
physical id	: 0
physical id	: 1
physical id	: 0
physical id	: 1
physical id	: 0
physical id	: 1
physical id	: 0
physical id	: 1
physical id	: 0
physical id	: 1
physical id	: 0
physical id	: 1
physical id	: 0
physical id	: 1
physical id	: 0


