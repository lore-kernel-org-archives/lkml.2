Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2BQPTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:19:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55962 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab2BQPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:19:50 -0500
MIME-Version: 1.0
In-Reply-To: <1329491708.2293.277.camel@twins>
References: <1329488869-7270-1-git-send-email-consul.kautuk@gmail.com>
	<1329491708.2293.277.camel@twins>
Date: Fri, 17 Feb 2012 10:19:49 -0500
Message-ID: <CAFPAmTRrW4rAiC6UPGCFWChyuAjtbn7pkXRm3L2_SYdrRQCBZQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] rmap: Staticize page_referenced_file and page_referenced_anon
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 10:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-02-17 at 09:27 -0500, Kautuk Consul wrote:
>> Staticize the page_referenced_anon and page_referenced_file
>> functions.
>> These functions are called only from page_referenced.
>
> Subject and changelog say: staticize, which I read to mean: make static.
> Yet what the patch does is make them inline ?!?

Yes, sorry my mistake. :)

>
> Also, if they're static and there's only a single callsite, gcc will
> already inline them, does this patch really make a difference?

I just sent this patch for what I thought was "correctness", but I guess
we can let this be if you are absolutely sure that all GCC cross compilers
for all platforms will guarantee inlining.



>
>> -static int page_referenced_anon(struct page *page,
>> +static inline int page_referenced_anon(struct page *page,
>
>


Please reply back if you feel I should resend this patch with modified
description.
Else, I'll just forget about this one. :)
