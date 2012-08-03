Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2HCWTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:19:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42230 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2HCWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:19:36 -0400
Message-ID: <501C4E92.1070801@gmail.com>
Date: Sat, 04 Aug 2012 00:20:02 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com> <1344003788-1417-2-git-send-email-levinsasha928@gmail.com> <20120803171515.GH15477@google.com> <501C407D.9080900@gmail.com> <20120803213017.GK15477@google.com> <501C458E.7050000@gmail.com> <20120803214806.GM15477@google.com>
In-Reply-To: <20120803214806.GM15477@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 11:48 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Aug 03, 2012 at 11:41:34PM +0200, Sasha Levin wrote:
>> I forgot to comment on that one, sorry.
>>
>> If we put hash entries after struct hash_table we don't take the
>> bits field size into account, or did I miss something?
> 
> So, if you do the following,
> 
> 	struct {
> 		struct {
> 			int i;
> 			long ar[];
> 		} B;
> 		long __ar_storage[32];
> 	} A;

struct A should have been an union, right?

> It should always be safe to dereference A.B.ar[31].  I'm not sure
> whether this is something guaranteed by C tho.  Maybe compilers are
> allowed to put members in reverse order but I think we already depend
> on the above.

why is accessing A.B.ar[31] safe?

__ar_storage is only 32*sizeof(long) bytes long, while struct B would need to be 32*sizeof(long) + sizeof(int) bytes long so that A.B.ar[31] access would be safe.


> Thanks.
> 

