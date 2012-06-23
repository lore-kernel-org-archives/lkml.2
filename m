Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2FWQIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 12:08:23 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:59713 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2FWQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 12:08:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20453.59620.255516.321417@quad.stoffel.home>
Date: Sat, 23 Jun 2012 12:03:48 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "John Stoffel" <john@stoffel.org>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 00/11] mm: scalable and unified
 arch_get_unmapped_area
In-Reply-To: <20120622144714.440f8529.akpm@linux-foundation.org>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	<20452.32826.165122.958868@quad.stoffel.home>
	<20120622144714.440f8529.akpm@linux-foundation.org>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> On Fri, 22 Jun 2012 10:24:58 -0400
Andrew> "John Stoffel" <john@stoffel.org> wrote:

>> >>>>> "Rik" == Rik van Riel <riel@surriel.com> writes:
>> 
Rik> A long time ago, we decided to limit the number of VMAs per
Rik> process to 64k. As it turns out, there actually are programs
Rik> using tens of thousands of VMAs.
>> 
>> 
Rik> Performance
>> 
Rik> Testing performance with a benchmark that allocates tens
Rik> of thousands of VMAs, unmaps them and mmaps them some more
Rik> in a loop, shows promising results.
>> 
>> How are the numbers for applications which only map a few VMAs?  Is
>> there any impact there?
>> 

Andrew> Johannes did a test for that: https://lkml.org/lkml/2012/6/22/219

I don't see that in his results.  But maybe (probably) I don't
understand what types of applications this change is supposed to
help.  I guess I worry that this will just keep slowing down other
apps. 

His tests seemed to be for just one VMA remapped with thousands in
use.  Or am I missing the fact that all VMAs are in the same pool?  

Andrew> Some regression with such a workload is unavoidable, I expect.
Andrew> We have to work out whether the pros outweigh the cons.  This
Andrew> involves handwaving.

Yup, it does.  Proof by vigorous handwaving is a time honored
tradition.  

And I do see that the numbers aren't that much poorer, I just keep
thinking that if we can speed up the corner case, can't we also speed
up the normal case with a better algorithm or data structure?

John
