Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab2CFMBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:01:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56360 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918Ab2CFMBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:01:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.60.20.101 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1331035288.2474.33.camel@edumazet-laptop>
Subject: Re: TCP_STREAM performance regression on commit b3613118
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Feng Tang <feng.tang@intel.com>, David Miller <davem@davemloft.net>,
        alex.shi@intel.com, linux-kernel@vger.kernel.org, tim.c.chen@intel.com,
        ying.huang@intel.com, netdev@vger.kernel.org
Date: Tue, 06 Mar 2012 04:01:28 -0800
In-Reply-To: <4F55CA25.2070503@redhat.com>
References: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20120217.133327.1178765872497293871.davem@davemloft.net>
	 <1330656317.21053.1411.camel@debian>
	 <20120301.220743.2174015405223036036.davem@davemloft.net>
	 <20120306081117.GA17375@feng-i7> <4F55CA25.2070503@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 mars 2012 à 16:26 +0800, Jason Wang a écrit :
> On 03/06/2012 04:11 PM, Feng Tang wrote:
> > On Thu, Mar 01, 2012 at 10:07:43PM -0500, David Miller wrote:
> >> >  From: Alex Shi<alex.shi@intel.com>
> >> >  Date: Fri, 02 Mar 2012 10:45:17 +0800
> >> >  
> >>> >  >  Add CC to tang feng, He is working on this issue.
> >> >  
> >> >  Is he?  I'm pretty sure this is due to the TCP receive window growing
> >> >  issue Eric Dumazet, Neal Cardwell and I are discussing in the thread
> >> >  starting at:
> >> >  
> >> >  http://marc.info/?l=linux-netdev&m=132916352815286&w=2
> > Yes, probably, as we did find some clue related with the tcp_r/wmem.
> >
> > Here is the regression we found:
> > On some machines, we found there is about 10% resgression of netperf
> > TCP-64K loopback test between 3.2 and 3.3-rc1. The exact test is:
> > ./netperf -t TCP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -s 32768 -S 32768 -m 4096
> >
> >
> > The test machine is a 2 socket Quad Core Core 2 Duo server(2.66GHz) with
> > 8 GB RAM. Following are the debug info (ifconfig/netstat -s/tcp_rwmem)
> > before and after the test:
> >
> > The most obvious differences I can see are:
> > 1) 311 GB vs 241 GB from ifconfig
> > 2) the difference of the tcp_r/wmem
> 
> Hi:
> 
> Could you try the newest kernel? Looks like the difference has been 
> already fixed by commit c43b874d5d714f271b80d4c3f49e05d0cbf51ed2.
> 

Most likely yes. 

tcp_rmem
4096    87380   87380
tcp_wmem
4096    16384   65536

Is way pessimistic :(




