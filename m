Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2DJHFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 03:05:52 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:52618 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752498Ab2DJHFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 03:05:50 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
To: David Rientjes <rientjes@google.com>, Colin Cross <ccross@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Tue, 10 Apr 2012 03:09:45 -0400
Message-ID: <web-723290478@zbackend1.aha.ru>
In-Reply-To: <alpine.DEB.2.00.1204091707580.21813@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org>
 <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
 <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
 <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
 <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com>
 <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com>
 <web-723076709@zbackend1.aha.ru>
 <alpine.DEB.2.00.1204091637280.21813@chino.kir.corp.google.com>
 <web-723082731@zbackend1.aha.ru>
 <alpine.DEB.2.00.1204091707580.21813@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After first I tested some hours the 1st,one-line patch by 
D.R., now is ready compiled and started to be tested his 
2nd patch, below.   I see he has it already comitted; it 
would have been better first wait to test it.

The loop suggested below, with this 2nd patch, gives 1560 
kB , compared with 1632 kb after the 1st patch, and 1432 
kB with kernel 3.3  .    On the other hand, 3.3 has 
clearly the same problem (even if not crashing, it's 
becoming often very slow, and then  there's running 
kmemleak, what I have to kill for return to the normal 
speed), but according this 'test' it would be good, so 
that it's questionable if this test is reliable.

As already reported, the 1st patch cured the problem at 
least subjectively.

To see if this 2nd patch is good, I have to wait now some 
hours and observe if the computer becomes slow or even 
crashs


wl


=================================================

On Mon, 9 Apr 2012 17:11:45 -0700 (PDT)
  David Rientjes <rientjes@google.com> wrote:
> On Mon, 9 Apr 2012, werner wrote:
> 
>> I continue now testing your first patch a few hours, if 
>>it's good or not.
>> Then, I can make another patch.  So you have still time 
>>to think and put all
>> together
>> what you want to be tested, and mail me that. Also 
>>explain me, if you want
>> other
>> patchs ADDITIONALLY or INSTEAD your first patch -- the 
>>best would be, to send
>> me
>> always accumulating patchs including everything together 
>>to be applied over
>> the
>> 'virgin' 3.4-rcX kernel.
>> For your information, I dont download the whole git, I 
>>download all 3.X.Y-rcZ
>> , and I
>> recompile everything again (patched), instead of 
>>compiling only the patched
>> subroutines.
>> 
> 
> Ok, when you want to test the latest patch, try this:
> 
> - revert back to the vanilla 3.4-rc2 kernel,
> 
> - boot and do this on the command line:
> 
> 	for i in $(seq 1 10000); do sleep 0 & done
> 	grep KernelStack /proc/meminfo
> 
> - record that number,
> 
> - apply the patch at https://lkml.org/lkml/2012/4/9/428,
> 
> - boot and do the same two command lines,
> 
> - compare the number with the previous number from the 
>first boot.
> 
> The number should be much lower after the patch is 
>applied.
> 
> Thanks!
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
