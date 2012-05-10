Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab2EJIkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:40:19 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:24381 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab2EJIkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:40:09 -0400
Message-ID: <4FAB7EE5.8010507@wanadoo.fr>
Date: Thu, 10 May 2012 10:40:05 +0200
From: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04> <20120428034257.GA2495@linux.vnet.ibm.com> <20120501000245.GA4329@linux.vnet.ibm.com> <4F9FA50C.9070600@wanadoo.fr> <20120501154513.GD2441@linux.vnet.ibm.com> <4FA3EAEE.9030601@wanadoo.fr> <20120504150411.GC2411@linux.vnet.ibm.com> <4FA44CF9.7050604@wanadoo.fr> <20120504231442.GT2411@linux.vnet.ibm.com>
In-Reply-To: <20120504231442.GT2411@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/05/2012 01:14, Paul E. McKenney a écrit :
> On Fri, May 04, 2012 at 11:41:13PM +0200, Pascal Chapperon wrote:
>> Le 04/05/2012 17:04, Paul E. McKenney a écrit :
>>> On Fri, May 04, 2012 at 04:42:54PM +0200, Pascal Chapperon wrote:
>>>> Le 01/05/2012 17:45, Paul E. McKenney a écrit :
>>>>
>>>>> Here is my RCU_FAST_NO_HZ patch stack on top of v3.4-rc4.
>>>>>
>>>>> Or you can pull branch fnh.2012.05.01a from:
>>>>>
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
>>>>>
>>>>> 							Thanx, Paul
>>>>>
>>>> I applied your global patch on top of v3.4-rc4. But the slowdown is
>>>> worse than before : boot sequence took 80s instead 20-30s (12s for
>>>> initramfs instead of 2s).
>>>>
>>>> I'll send you rcu tracing log in a second mail.
>>>
>>> Hmmm...  Well, I guess I am glad that I finally did something that
>>> had an effect, but I sure wish that the effect had been in the other
>>> direction!
>>>
>>> Just to make sure I understand: the difference between the 20-30s and
>>> the 80s is exactly the patch I sent you?
>>>
>>> 							Thanx, Paul
>>>
>>>
>> Yes. Exactly same kernel config as in previous results, I applied
>> your patch against v3.4-rc4, and sorry, the result is exactly what I
>> said;
>> I saw that your global patch was quite huge, and addresses things which
>> are not directly related with the initial patch (commit
>> 7cb92499000e3c86dae653077b1465458a039ef6); maybe a side effect?
>>
>> However, I'm ready to try this patch on my smaller laptop which
>> supports well CONFIG_FAST_NO_HZ=y and systemd, if you think it can
>> help ?
>>
>> Another thought: this issue as nothing to do with i7 Hyper-threading
>> capacities ? (as I test core2duo, Pentium ulv in same conditions and I
>> don't encountered any slowdown ?)
>
> Well, one possibility is that your setup starts the jiffies counter
> at some interesting value.  The attached patch (also against v3.4-rc4)
> applies a bit more paranoia to the initialization to handle this
> and other possibilities.
>
> 							Thanx, Paul
>
> ------------------------------------------------------------------------
I tried your new patch against v3.4-rc5 and saw no improvement :
still 75 s. for the boot sequence.

I'll send you the logs in a second mail.

Pascal


