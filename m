Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2JAPYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:24:34 -0400
Received: from smtp.getmail.no ([84.208.15.66]:39880 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab2JAPYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:24:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: Mike Galbraith <efault@gmx.de>
Subject: Re: The 10ms averager in fair.c
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
Date: Mon, 01 Oct 2012 15:24:28 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wlh4u2xj6426ze@millennium.getinternet.no>
In-reply-to: <1349064397.6957.26.camel@marge.simpson.net>
User-Agent: Opera Mail/12.02 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Oct 2012 06:06:37 +0200, Mike Galbraith <efault@gmx.de> wrote:

> On Sun, 2012-09-30 at 13:44 +0200, Uwaysi Bin Kareem wrote:
>> Hiya. I just had an initial look at fair.c
>>
>> There seems to be a 10ms averager in there?
>>
>> You are aware that that means you work on delayed values?
>>
>> Isn`t that counterintuitive to the principle of sharing?
>
> Not if you want to be able to use lots of groups, and still do something
> other than in-kernel arithmetic.
>
> -Mike
>

"Use lots of groups"? I don`t even see the point with that. Currently  
doesn`t cfs manipulate nice levels? If you set constant nice levels, and  
remove the filter, things will work more as expected. High nice value,  
should be short slice. That is your "group", for instance "low priority  
stuff".

That a filter filters out the initial cpu spike, only to starve it and  
elevate the priority later, is silly. That is delayed execution.

Now I haven`t looked that close at the whole scheduler yet, but no.. I  
can`t possibly think what a filter does in there, that smears at 100uS  
spike, over 10ms.

Btw, I did set it to 1ns, and it only improved things. So that it should  
have some function seems odd to me.

Are you sure this isn`t just a design-philosophy that was done, without  
much knowledge of filters?

Peace Be With You.
