Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1HCUof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:44:35 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:34658 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1HCUo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:44:29 -0400
Message-ID: <4E39B31D.6010603@cs.tu-berlin.de>
Date: Wed, 03 Aug 2011 22:44:13 +0200
From: =?UTF-8?B?SmFuIFNjaMO2bmhlcnI=?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110508 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFCv2 3/8] sched: Handle on_list ancestor in list_add_leaf_cfs_rq()
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>	 <1311793825-31933-4-git-send-email-schnhrr@cs.tu-berlin.de> <1312293037.1147.181.camel@twins>
In-Reply-To: <1312293037.1147.181.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.08.2011 15:50, schrieb Peter Zijlstra:
> On Wed, 2011-07-27 at 21:10 +0200, Jan H. Schönherr wrote:
[...]
>> +        * c) If there are concurrent readers, they must already know this
>> +        *    node.
>> +        *
>> +        *    If we have to add case 1 nodes, they are collected in the
>> +        *    beginning and cannot be reached by readers until they are
>> +        *    spliced. Furthermore, after they are spliced, we will not
>> +        *    encounter more case 1 nodes higher up in the task group
>> +        *    hierarchy. For this reason any reader on an earlier collected
>> +        *    case 2 node must know all nodes that we collect later.
>> +        */
>> +       list_add_tail_nobackref(&cfs_rq->leaf_cfs_rq_list, leaf_cfs_rqs); 
> 
> I think there's an argument for not adding _nobackref and simply
> open-coding the operation here. Could there possibly be another user
> that wants this? 
> 
> Furthermore, since its tricky like hell every site would want a comment
> like the above explaining exactly what and why, and when you put in that
> much effort, you might as well write the list-op itself too.

Will do.

However, when reassigning next-pointers of deleted nodes to not deleted
nodes (e. g. the list head itself) as outlined in the other mail,
we'll have to use rcu-aware assignments to really prevent the race with
physical deletion. Therefore, the condition c) still listed above
will be unnecessary, then.

Regards
Jan
