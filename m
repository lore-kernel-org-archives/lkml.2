Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0FNHt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:49:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33355 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0FNHt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:49:57 -0400
Date: Mon, 14 Jun 2010 09:49:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: warning from gcc version 4.6.0 20100416
Message-ID: <20100614074955.GB17092@basil.fritz.box>
References: <4C11A598.8090504@gmail.com> <4C158335.9000906@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C158335.9000906@tmr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 09:17:41PM -0400, Bill Davidsen wrote:
> Justin P. Mattock wrote:
>> o.k. andi,
>>
>> here is the rest of the warnings that
>> I see when compiling the kernel
>>
>> I can try and create some patches for
>> this(hopefully!!)
>>
> There is no great solution to this, in a fair number of cases the fix would 
> slow the code or make it harder to read, so some of these probably don't 

Sorry that's wrong: the optimizer will generate the same
code anyways as if the unused variable was not  there
because it eliminates unused variables.

So fixing this cannot make code slower.

I also don't see how unused variables make the code easier 
to read.

The only difficult case sometimes is with #ifdef code,
that has to be handled case by case. One elegant solution
is to replace the ifdef code with an inline.

> want a fix. Of course some clearly are errors, so you are doing something 

All warnings should be fixed, I only left those in that 
are real code bugs if I couldn't fix the code.

Kernel builds are expected to be relatively warning free
so that you can easily spot new warnings.

But eventually someone who knows the code better has to
fix that bug.

--Andi
