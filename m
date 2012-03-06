Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab2CFSYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:24:00 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:43937 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab2CFSX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:23:59 -0500
Message-ID: <4F56563C.2070206@hp.com>
Date: Tue, 06 Mar 2012 10:23:56 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: David Miller <davem@davemloft.net>, alex.shi@intel.com,
        eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        tim.c.chen@intel.com, ying.huang@intel.com, netdev@vger.kernel.org
Subject: Re: TCP_STREAM performance regression on commit b3613118
References: <1329472239.2861.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20120217.133327.1178765872497293871.davem@davemloft.net> <1330656317.21053.1411.camel@debian> <20120301.220743.2174015405223036036.davem@davemloft.net> <20120306081117.GA17375@feng-i7>
In-Reply-To: <20120306081117.GA17375@feng-i7>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 12:11 AM, Feng Tang wrote:
> On some machines, we found there is about 10% resgression of netperf
> TCP-64K loopback test between 3.2 and 3.3-rc1. The exact test is:
> ./netperf -t TCP_STREAM -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -s 32768 -S 32768 -m 4096

Side comment on the netperf command line.  The maximum confidence 
interactions is silently capped at 30, so that might as well be "-i 
30,3" 
http://www.netperf.org/svn/netperf2/tags/netperf-2.5.0/doc/netperf.html#index-g_t_002di_002c-Global-28

Also, for reproducibility, it might be desirable to pin netperf and 
netserver to a specific CPU or CPUs.  That would be with a global -T 
option: 
http://www.netperf.org/svn/netperf2/tags/netperf-2.5.0/doc/netperf.html#index-g_t_002dT_002c-Global-41

happy benchmarking,

rick jones
