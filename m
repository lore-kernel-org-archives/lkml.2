Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2KBUdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:33:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26661 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2KBUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:33:43 -0400
Message-ID: <50942E05.9040607@oracle.com>
Date: Fri, 02 Nov 2012 16:33:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, mingo@kernel.org,
        hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        peter.senna@gmail.com
Subject: Re: [RFC] hlist: drop the node parameter from iterators
References: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com> <CA+55aFxxdFCiOHEz_xWx1vjMkpQzab_Mdmd2dweknayhVBx6kA@mail.gmail.com> <50932F6E.5060506@oracle.com> <CA+55aFy9QSZhFpEt=iEvYTHMGhd3ARwpHfZ+PghHNAEcP6Ko7g@mail.gmail.com>
In-Reply-To: <CA+55aFy9QSZhFpEt=iEvYTHMGhd3ARwpHfZ+PghHNAEcP6Ko7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 04:16 PM, Linus Torvalds wrote:
> On Thu, Nov 1, 2012 at 7:26 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>
>> Here are some stats:
>>
>>  - Applying the patch from -next on top of your current git head
>> results in 3 conflicts.
>>
>>  - Applying the patch from your current git head on top of v3.6 results
>> in 18 conflicts.
>>
>>  - Applying the patch from 3.6 on top of 3.5 results in 25 conflicts.
> 
> Ok, that sounds slightly painful, but not unmanageable.
> 
> Can you send me the actual patch, and I'll mull on this a bit more? I
> could run the coccinelle script myself, but I assume (maybe
> incorrectly?) that there are manual fixes to clean some stuff up
> afterwared..

You're right about that. There are 2 things which needs to be done after
running the script:

 - Coccinelle doesn't handle cases where there are multiple variables in
the declaration. That means that things like:

	struct hlist_node *node, *tmp;

Have to be fixed manually.

That's common when hlist_for_each_entry_safe() is used afterwards.

 - Some places actually use node for their needs, while coccinelle can
automatically fix that to use '(ptr)->member', I'd rather go through those
places manually and make sure we're doing the right thing.


Do you want the patch on top of your git head, or on top of -next?


Thanks,
Sasha

