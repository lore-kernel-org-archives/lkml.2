Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0FNOvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:51:18 -0400
Received: from mail.tmr.com ([64.65.253.246]:33940 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab0FNOvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:51:16 -0400
Message-ID: <4C1641D7.3070802@tmr.com>
Date: Mon, 14 Jun 2010 10:51:03 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: warning from gcc version 4.6.0 20100416
References: <4C11A598.8090504@gmail.com> <4C158335.9000906@tmr.com> <20100614074955.GB17092@basil.fritz.box>
In-Reply-To: <20100614074955.GB17092@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Jun 13, 2010 at 09:17:41PM -0400, Bill Davidsen wrote:
>   
>> Justin P. Mattock wrote:
>>     
>>> o.k. andi,
>>>
>>> here is the rest of the warnings that
>>> I see when compiling the kernel
>>>
>>> I can try and create some patches for
>>> this(hopefully!!)
>>>
>>>       
>> There is no great solution to this, in a fair number of cases the fix would 
>> slow the code or make it harder to read, so some of these probably don't 
>>     
>
> Sorry that's wrong: the optimizer will generate the same
> code anyways as if the unused variable was not  there
> because it eliminates unused variables.
>
>   
If one puts an 'if' around the variable set (I've seen it) the test may 
well take longer than the assign, assuming that there's a case where the 
assign is done.
> So fixing this cannot make code slower.
>
> I also don't see how unused variables make the code easier 
> to read.
>
>   
No, my point was that putting a bunch of ifdef statements in to avoid 
the warning will make the code harder to read.

> The only difficult case sometimes is with #ifdef code,
> that has to be handled case by case. One elegant solution
> is to replace the ifdef code with an inline.
>
>   
>> want a fix. Of course some clearly are errors, so you are doing something 
>>     
>
> All warnings should be fixed, I only left those in that 
> are real code bugs if I couldn't fix the code.
>
> Kernel builds are expected to be relatively warning free
> so that you can easily spot new warnings.
>
> But eventually someone who knows the code better has to
> fix that bug.
>
> --Andi
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

