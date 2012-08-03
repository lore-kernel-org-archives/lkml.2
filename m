Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2HCVlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:41:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35031 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2HCVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:41:09 -0400
Message-ID: <501C458E.7050000@gmail.com>
Date: Fri, 03 Aug 2012 23:41:34 +0200
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
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com> <1344003788-1417-2-git-send-email-levinsasha928@gmail.com> <20120803171515.GH15477@google.com> <501C407D.9080900@gmail.com> <20120803213017.GK15477@google.com>
In-Reply-To: <20120803213017.GK15477@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 11:30 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Aug 03, 2012 at 11:19:57PM +0200, Sasha Levin wrote:
>>> Is this supposed to be embedded in struct definition?  If so, the name
>>> is rather misleading as DEFINE_* is supposed to define and initialize
>>> stand-alone constructs.  Also, for struct members, simply putting hash
>>> entries after struct hash_table should work.
>>
>> It would work, but I didn't want to just put them in the union since
>> I feel it's safer to keep them in a separate struct so they won't be
>> used by mistake,
> 
> Just use ugly enough pre/postfixes.  If the user still accesses that,
> it's the user's fault.

I forgot to comment on that one, sorry.

If we put hash entries after struct hash_table we don't take the bits field size into account, or did I miss something?
