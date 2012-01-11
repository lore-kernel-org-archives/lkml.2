Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2AKSX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:23:57 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:32850 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab2AKSX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:23:56 -0500
Message-ID: <4F0DD365.6070200@parallels.com>
Date: Wed, 11 Jan 2012 22:22:29 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [RFC] on general object IDs again
References: <20120111161939.GI8752@moon> <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com> <20120111175952.GI466@moon> <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
In-Reply-To: <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 10:19 PM, KOSAKI Motohiro wrote:
>> Hi Kosaki,
>>
>> the idea on user-space is something like
>>
>>  - collect all pids to dump
>>  - collect IDs for every pid
>>  - sort the IDs obtained
>>  - find the same IDs (which will be kind of find intersections in a sets of IDs) and
>>   set up CLONE_ flags on restore procedure as appropriate (for example if
>>   GEN_OBJ_ID_VM IDs for two or more tasks are the same we need to use CLONE_VM
>>   at restore time, and so on).
> 
> Then, you only need to compare. not any other calculation. i.e. only
> need id uniqueness.
> And any resource are referenced from tasks. so, can you reuse pid for
> this? example,
> two taska share one mm.
> 
> task-a(pid: 100)
>               |-----------------mm
> task-b(pid: 200)
> 
> 
> gen_obj_id(task-b, GEN_OBJ_ID_VM) return 100. (youngest pid of referenced tasks)

We can, but determining the youngest pid for an mm struct is O(N) algo.
Having N tasks with N mm_structs getting the sharing picture becomes O(N^2).

> .
> 

