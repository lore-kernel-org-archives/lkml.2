Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2BVXDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:03:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40520 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750859Ab2BVXD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:03:28 -0500
Message-ID: <4F45742F.1070605@fb.com>
Date: Wed, 22 Feb 2012 15:03:11 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: route add default fails with ESRCH?
References: <4F3F0158.2020406@fb.com> <4F4541E5.5040700@fb.com> <alpine.LFD.2.00.1202222319150.1603@ja.ssi.bg> <4F45638B.30305@fb.com>
In-Reply-To: <4F45638B.30305@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-22_06:2012-02-21,2012-02-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/12 1:52 PM, Arun Sharma wrote:

> I'll try to figure out why my RT_TABLE_MAIN was empty after my network
> startup scripts finished. But given my experience with 2.6.38, fib_hash
> handled this case just fine and fib_trie broke it :(
>

Turns out that we had a /sbin/ifup-local that deleted all the routes 
including default gw and populated the route afresh.

route del default gw ...
ip route | grep -v scope | awk '{print $1}' | while read route; do ip 
route flush $route; done

This worked fine with fib_hash, but breaks with fib_trie. I'll 
investigate why this was done and look for a workaround if possible.

  -Arun


