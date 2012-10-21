Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2JUNXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 09:23:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab2JUNXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 09:23:13 -0400
Message-ID: <5083F720.2030003@redhat.com>
Date: Sun, 21 Oct 2012 09:22:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 4/2] numa, mm: Rename the PROT_NONE fault handling functions
References: <20121018171821.7f1b1683@cuia.bos.redhat.com> <20121018172021.0b1f6e3d@cuia.bos.redhat.com> <1350646863.30157.13.camel@twins> <50815EA5.5080502@redhat.com> <20121019205407.GA9132@gmail.com> <20121021125007.GB19535@gmail.com>
In-Reply-To: <20121021125007.GB19535@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 08:50 AM, Ingo Molnar wrote:
>
> * Ingo Molnar <mingo@kernel.org> wrote:
>
>>>> I don't much care either way, but I was thinking walken
>>>> might want to use something similar to do WSS estimation,
>>>> in which case the NUMA name is just as wrong.
>>>
>>> That's a good point. I had not considered other uses of the
>>> same code.
>>
>> Renaming the functions for more clarity still makes sense IMO:
>> we could give it a _wss or _working_set prefix/postfix?
>
> So, to not drop your patch on the floor I've modified it as per
> the patch below.
>
> The _wss() names signal that these handlers are used for a
> specific purpose, they are not related to the regular PROT_NONE
> handling code.

Michel indicated that he does not use PROT_NONE for his
working set estimation code, but instead checks the
accessed bits in the page tables.

Since NUMA migration is the only user of PROT_NONE ptes
in normal vmas, maybe _numa is the right suffix after all?

-- 
All rights reversed
