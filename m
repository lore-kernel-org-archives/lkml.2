Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687Ab2KBC1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 22:27:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38754 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762588Ab2KBC1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 22:27:45 -0400
Message-ID: <50932F6E.5060506@oracle.com>
Date: Thu, 01 Nov 2012 22:26:54 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, mingo@kernel.org,
        hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        peter.senna@gmail.com
Subject: Re: [RFC] hlist: drop the node parameter from iterators
References: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com> <CA+55aFxxdFCiOHEz_xWx1vjMkpQzab_Mdmd2dweknayhVBx6kA@mail.gmail.com>
In-Reply-To: <CA+55aFxxdFCiOHEz_xWx1vjMkpQzab_Mdmd2dweknayhVBx6kA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 08:59 PM, Linus Torvalds wrote:
> On Thu, Nov 1, 2012 at 4:06 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> I'm not sure why, but the hlist for each entry iterators were conceived
>> differently from the list ones. While the list ones are nice and elegant:
>>
>>         list_for_each_entry(pos, head, member)
>>
>> The hlist ones were greedy and wanted an extra parameter:
>>
>>         hlist_for_each_entry(tpos, pos, head, member)
>>
>> Why did they need an extra pos parameter? I'm not quite sure. Not only
>> they don't really need it, it also prevents the iterator from looking
>> exactly like the list iterator, which is unfortunate.
>>
>> [..]
>>  170 files changed, 481 insertions(+), 879 deletions(-)
>>
>> Yes, beyond making hlist prettier, we also drop 400 lines. win-win?
> 
> So this has been discussed before, and one of the problems with this
> is just the pain of maintenance. This tends to cause annoyances for
> merging, but also for -stable backporting etc, because it just results
> in a lot of noise.
> 
> Now, the hlist_for_each() case isn't used by quite as many sites as
> some of the others helpers like this, so maybe the pain isn't horribly
> bad, but in general I do tend to get nervous about "let's clean it up"
> when it touches hundreds of files.
> 
> Your thing looks nice in that it has the coccinelle script (which
> hopefully means that we really get them all), but just out of
> interest, how different is the patch after running the script on both
> 
>  (a) my current -git head
>  (b) linux-next
> 
> because differences (other than just line numbers) imply conflicts.
> How many differences are we talking about? None? Two? Twenty?
> 
> (That said, right now linux-next is tiny. It might be more interesting
> to look at the linux-3.5 vs linux-3.6 to get more of a feel for
> differences between releases. Doing just the diff+grep thing, there's
> quite a few changes around hlist_for_each_entry() uses)

Instead of diffing diffs, I've just tried applying different versions
of the patch of different trees, and then looking at how many conflicts
happen as a result of that. I think it's probably a good indication of
how many conflicts this change would really cause.

Here are some stats:

 - Applying the patch from -next on top of your current git head
results in 3 conflicts.

 - Applying the patch from your current git head on top of v3.6 results
in 18 conflicts.

 - Applying the patch from 3.6 on top of 3.5 results in 25 conflicts.



Thanks,
Sasha

