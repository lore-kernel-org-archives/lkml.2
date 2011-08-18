Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1HRMpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:45:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64080 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab1HRMpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:45:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAG1a4rsO7JDqmYiwyxPrAHdLNbJt+wqymSzU9i1dv5w5C2OFog@mail.gmail.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
 <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com>
 <1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com>
 <201108111938.25836.vda.linux@googlemail.com> <CAG1a4rsO7JDqmYiwyxPrAHdLNbJt+wqymSzU9i1dv5w5C2OFog@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 18 Aug 2011 14:44:56 +0200
Message-ID: <CAK1hOcM5u-zB7fUnR5QVJGBrEnLMhK9Q+EmWBknThga70UQaLw@mail.gmail.com>
Subject: Re: running of out memory => kernel crash
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Mahmood Naderan <nt_mahmood@yahoo.com>,
        David Rientjes <rientjes@google.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 4:18 AM, Pavel Ivanov <paivanof@gmail.com> wrote:
>>> Why "killing" does not appear here? Why it try to "find some
>>> recently used page"?
>>
>> Because killing is the last resort. As long as kernel can free
>> a page by dropping an unmodified file-backed page, it will do that.
>> When there is nothing more to drop, and still more free pages
>> are needed, _then_ kernel will start oom killing.
>
> I have a little concern about this explanation of yours. Suppose we
> have some amount of more or less actively executing processes in the
> system. Suppose they started to use lots of resident memory. Amount of
> memory they use is less than total available physical memory but when
> we add total size of code for those processes it would be several
> pages more than total size of physical memory. As I understood from
> your explanation in such situation one process will execute its time
> slice, kernel will switch to other one, find that its code was pushed
> out of RAM, read it from disk, execute its time slice, switch to next
> process, read its code from disk, execute and so on. So system will be
> virtually unusable because of constantly reading from disk just to
> execute next small piece of code. But oom will never be firing in such
> situation. Is my understanding correct?

Yes.

> Shouldn't it be considered as an unwanted behavior?

Yes. But all alternatives (such as killing some process) seem to be worse.

-- 
vda
