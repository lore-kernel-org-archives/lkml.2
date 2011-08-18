Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1HRO1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:27:19 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:63080 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab1HRO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:27:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAK1hOcM5u-zB7fUnR5QVJGBrEnLMhK9Q+EmWBknThga70UQaLw@mail.gmail.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
 <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com>
 <1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com>
 <201108111938.25836.vda.linux@googlemail.com> <CAG1a4rsO7JDqmYiwyxPrAHdLNbJt+wqymSzU9i1dv5w5C2OFog@mail.gmail.com>
 <CAK1hOcM5u-zB7fUnR5QVJGBrEnLMhK9Q+EmWBknThga70UQaLw@mail.gmail.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Thu, 18 Aug 2011 10:26:47 -0400
Message-ID: <CAG1a4rus+VVhhB3ayuDF2pCQDusLekGOAxf33+u_uzxC1yz1MA@mail.gmail.com>
Subject: Re: running of out memory => kernel crash
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Mahmood Naderan <nt_mahmood@yahoo.com>,
        David Rientjes <rientjes@google.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 8:44 AM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
>> I have a little concern about this explanation of yours. Suppose we
>> have some amount of more or less actively executing processes in the
>> system. Suppose they started to use lots of resident memory. Amount of
>> memory they use is less than total available physical memory but when
>> we add total size of code for those processes it would be several
>> pages more than total size of physical memory. As I understood from
>> your explanation in such situation one process will execute its time
>> slice, kernel will switch to other one, find that its code was pushed
>> out of RAM, read it from disk, execute its time slice, switch to next
>> process, read its code from disk, execute and so on. So system will be
>> virtually unusable because of constantly reading from disk just to
>> execute next small piece of code. But oom will never be firing in such
>> situation. Is my understanding correct?
>
> Yes.
>
>> Shouldn't it be considered as an unwanted behavior?
>
> Yes. But all alternatives (such as killing some process) seem to be worse.

Could you elaborate on this? We have a completely unusable server
which can be revived only by hard power cycling (administrators won't
be able to log in because sshd and shell will fall victims of the same
unending disk reading). And as an alternative we can kill some process
and at least allow administrator to log in and check if something else
can be done to make server feel better. Why is it worse?

I understand that it could be very hard to detect such situation but
at least it's worth trying I think.


Pavel
