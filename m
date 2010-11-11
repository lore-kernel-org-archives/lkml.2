Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0KKSTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:19:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55116 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0KKSTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:19:06 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CDC333E.4070104@s5r6.in-berlin.de>
Date: Thu, 11 Nov 2010 19:17:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com,
        peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, kevin.granade@gmail.com,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average
 (EWMA) function
References: <20101111034756.15014.2156.stgit@localhost6.localdomain6> <20101110200231.aaa51b47.akpm@linux-foundation.org> <201011111421.49464.br1@einfach.org>
In-Reply-To: <201011111421.49464.br1@einfach.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Randolf wrote:
> On Thu November 11 2010 13:02:31 Andrew Morton wrote:
>> So perhaps it would be best to merge this via the wireless tree, so
>> everything exists in one place and it can be fed into linux-next and
>> into mainline in an orderly fashion.
>>
>> If that sounds like a plan then I can send this patch in John's
>> direction.  Which means that if he merges it into mainline without also
>> merging any of your patches which _use_ this function then we still end
>> up with unused code in mainline, but at least that way it wasn't my fault
>> ;)
>>
>> Let me know your thoughts?
> 
> Sounds like a good plan to me. But let's hear Johns opinion.
> 
> I have a patch or two using this function, which I hope will get merged into 
> wireless-testing soon after, but obviously it's up to John. There are more 
> places in the wireless part which could make use of this function (right now 
> each have their own EWMA implementation), and I'll try to get them all 
> updated, but finally it's the individual maintainers, who decide if they want 
> to make that change or not, I guess.

It seems totally clear-cut to me that code like this is submitted together
with at least one call site, and it is submitted through the tree in which
that call site is maintained.

>> (And it's a bit sad that the function will exist in the base vmlinux
>> even for people who don't ever use it, but that's a problem which we
>> don't really have a good solution for).
> 
> Hmm, should I switch it back to all inlines?

Add a hidden Kconfig variable for it which is SELECTed by those Kconfig
prompts that require it?  That's the good solution that we use for a number of
similar library functions.
$ cat lib/Makefile

> On the other hand, if a generic EWMA function is useful at all I guess it 
> could be used in many places all over the kernel. Unfortunately I don't have 
> time and knowledge to find all these places and update them to use the generic 
> code.

Don't worry.  There are people who specialize in this sort of activity.

Two remarks on your patch:

You use WARN_ON in lib/average.c.  You should include <linux/bug.h>.

Why do ewma_init() and ewma_add() return their first argument?  They look to
me like they can be straight-forward void functions.
-- 
Stefan Richter
-=====-==-=- =-== -=-==
http://arcgraph.de/sr/
