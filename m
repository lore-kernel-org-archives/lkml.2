Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0CUToM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:44:12 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:57145 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771Ab0CUToL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:44:11 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 15:44:11 EDT
Message-ID: <4BA674F1.6070603@nagafix.co.uk>
Date: Mon, 22 Mar 2010 02:35:13 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <4BA250BF.80704@codemonkey.ws> <20100318162853.GB447@elte.hu> <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu>
In-Reply-To: <20100321191742.GD25922@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 02:17 AM, Ingo Molnar wrote:
> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>    
>> On 03/19/2010 03:53 AM, Ingo Molnar wrote:
>>      
>>> * Avi Kivity<avi@redhat.com>   wrote:
>>>        
>>>>> There were two negative reactions immediately, both showed a fundamental
>>>>> server versus desktop bias:
>>>>>
>>>>>   - you did not accept that the most important usecase is when there is a
>>>>>     single guest running.
>>>>>            
>>>> Well, it isn't.
>>>>          
>>> Erm, my usability points are _doubly_ true when there are multiple guests ...
>>>
>>> The inconvenience of having to type:
>>>
>>>    perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
>>>    --guestmodules=/home/ymzhang/guest/modules top
>>>
>>> is very obvious even with a single guest. Now multiply that by more guests ...
>>>        
>> If you want to improve this, you need to do the following:
>>
>> 1) Add a userspace daemon that uses vmchannel that runs in the guest and can
>>     fetch kallsyms and arbitrary modules.  If that daemon lives in
>>     tools/perf, that's fine.
>>      
> Adding any new daemon to an existing guest is a deployment and usability
> nightmare.
>    
Absolutely. In most cases it is not desirable, and you'll find that in a 
lot of cases it is not even possible - for non-technical reasons.
One of the main benefits of virtualization is the ability to manage and 
see things from the outside.
> The basic rule of good instrumentation is to be transparent. The moment we
> have to modify the user-space of a guest just to monitor it, the purpose of
> transparent instrumentation is defeated.
>    
Not to mention Heisenbugs and interference.

Cheers
Antoine

> That was one of the fundamental usability mistakes of Oprofile.
>
> There is no 'perf' daemon - all the perf functionality is _built in_, and for
> very good reasons. It is one of the main reasons for perf's success as well.
>
> Now Qemu is trying to repeat that stupid mistake ...
>
> So please either suggest a different transparent solution that is technically
> better than the one i suggested, or you should concede the point really.
>
> Please try think with the heads of our users and developers and dont suggest
> some weird ivory-tower design that is totally impractical ...
>
> And no, you have to code none of this, we'll do all the coding. The only thing
> we are asking is for you to not stand in the way of good usability ...
>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

