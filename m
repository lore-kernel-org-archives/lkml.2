Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2GTRZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:25:38 -0400
Received: from mx2.netapp.com ([216.240.18.37]:31317 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab2GTRZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:25:36 -0400
X-IronPort-AV: E=Sophos;i="4.77,623,1336374000"; 
   d="scan'208";a="667401686"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Joe Perches <joe@perches.com>
CC: "David S. Miller" <davem@davemloft.net>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Chuck Lever" <chuck.lever@oracle.com>,
        "<linux-nfs@vger.kernel.org>" <linux-nfs@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sunrpc: clnt: Add missing braces
Thread-Topic: [PATCH] sunrpc: clnt: Add missing braces
Thread-Index: AQHNZRGODGH4E85l6U+xlliDRUfV/Zcy2uKAgAAJn4A=
Date: Fri, 20 Jul 2012 17:25:27 +0000
Message-ID: <B303B8C0-4BB4-4900-84F4-457E9CF291D7@netapp.com>
References: <1342635431.9551.41.camel@joe2Laptop>
 <1342803059.21447.45.camel@joe2Laptop>
In-Reply-To: <1342803059.21447.45.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7EE93B58910E5246999176117BEB63F0@tahoe.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No. It should go through the NFS client tree.

I can queue it up.


--
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

On Jul 20, 2012, at 6:50 PM, Joe Perches wrote:

> On Wed, 2012-07-18 at 11:17 -0700, Joe Perches wrote:
>> Add a missing set of braces that commit 4e0038b6b24
>> ("SUNRPC: Move clnt->cl_server into struct rpc_xprt")
>> forgot.
>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>> net/sunrpc/clnt.c |    3 ++-
>> 1 files changed, 2 insertions(+), 1 deletions(-)
>> 
>> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
>> index f56f045..aaf70aa 100644
>> --- a/net/sunrpc/clnt.c
>> +++ b/net/sunrpc/clnt.c
>> @@ -1844,12 +1844,13 @@ call_timeout(struct rpc_task *task)
>> 		return;
>> 	}
>> 	if (RPC_IS_SOFT(task)) {
>> -		if (clnt->cl_chatty)
>> +		if (clnt->cl_chatty) {
>> 			rcu_read_lock();
>> 			printk(KERN_NOTICE "%s: server %s not responding, timed out\n",
>> 				clnt->cl_protname,
>> 				rcu_dereference(clnt->cl_xprt)->servername);
>> 			rcu_read_unlock();
>> +		}
>> 		if (task->tk_flags & RPC_TASK_TIMEOUT)
>> 			rpc_exit(task, -ETIMEDOUT);
>> 		else
> 
> Hi David.
> 
> I think it'd be good to get this into 3.6 as a bug fix.
> 
> This is marked in netdev patchwork as "not applicable".
> 
> Do you need the sunrpc maintainers to apply or ack it
> and then push it to you?
> 
> Trond?  Bruce?
> 

