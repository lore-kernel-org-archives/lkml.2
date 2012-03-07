Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2CGC44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 21:56:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:9862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab2CGC4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 21:56:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125939605"
Date: Wed, 7 Mar 2012 10:55:25 +0800
From: Feng Tang <feng.tang@intel.com>
To: Jason Wang <jasowang@redhat.com>
Cc: David Miller <davem@davemloft.net>, alex.shi@intel.com,
        eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        tim.c.chen@intel.com, ying.huang@intel.com, netdev@vger.kernel.org
Subject: Re: TCP_STREAM performance regression on commit b3613118
Message-ID: <20120307025525.GB21919@feng-i7>
References: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120217.133327.1178765872497293871.davem@davemloft.net>
 <1330656317.21053.1411.camel@debian>
 <20120301.220743.2174015405223036036.davem@davemloft.net>
 <20120306081117.GA17375@feng-i7>
 <4F55CA25.2070503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F55CA25.2070503@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 04:26:13PM +0800, Jason Wang wrote:
> On 03/06/2012 04:11 PM, Feng Tang wrote:
> >On Thu, Mar 01, 2012 at 10:07:43PM -0500, David Miller wrote:
> >>>  From: Alex Shi<alex.shi@intel.com>
> >>>  Date: Fri, 02 Mar 2012 10:45:17 +0800
> >>>
> >>>>  >  Add CC to tang feng, He is working on this issue.
> >>>  >  Is he?  I'm pretty sure this is due to the TCP receive
> >>window growing
> >>>  issue Eric Dumazet, Neal Cardwell and I are discussing in the thread
> >>>  starting at:
> >>>  >  http://marc.info/?l=linux-netdev&m=132916352815286&w=2
> >Yes, probably, as we did find some clue related with the tcp_r/wmem.
> >
> >Here is the regression we found:
> >On some machines, we found there is about 10% resgression of netperf
> >TCP-64K loopback test between 3.2 and 3.3-rc1. The exact test is:
> >./netperf -t TCP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -s 32768 -S 32768 -m 4096
> >
> >
> >The test machine is a 2 socket Quad Core Core 2 Duo server(2.66GHz) with
> >8 GB RAM. Following are the debug info (ifconfig/netstat -s/tcp_rwmem)
> >before and after the test:
> >
> >The most obvious differences I can see are:
> >1) 311 GB vs 241 GB from ifconfig
> >2) the difference of the tcp_r/wmem
> 
> Hi:
> 
> Could you try the newest kernel? Looks like the difference has been
> already fixed by commit c43b874d5d714f271b80d4c3f49e05d0cbf51ed2.

Yeah, with the newest kernel, the regression of this simple test is gone,
the performance difference with 3.2 kernel is now only about 1-2%. Thanks
for the info.

- Feng

> 
> Thanks
