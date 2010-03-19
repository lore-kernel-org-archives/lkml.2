Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0CSNCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 09:02:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64588 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0CSNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 09:02:14 -0400
Message-ID: <4BA3747F.60401@codemonkey.ws>
Date: Fri, 19 Mar 2010 07:56:31 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <4BA23FE1.5050402@codemonkey.ws> <20100318151737.GA2875@elte.hu> <4BA250BF.80704@codemonkey.ws> <20100318162853.GB447@elte.hu> <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu>
In-Reply-To: <20100319085346.GG12576@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 03:53 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>>> There were two negative reactions immediately, both showed a fundamental
>>> server versus desktop bias:
>>>
>>>   - you did not accept that the most important usecase is when there is a
>>>     single guest running.
>>>        
>> Well, it isn't.
>>      
> Erm, my usability points are _doubly_ true when there are multiple guests ...
>
> The inconvenience of having to type:
>
>    perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
>    --guestmodules=/home/ymzhang/guest/modules top
>
> is very obvious even with a single guest. Now multiply that by more guests ...
>    

If you want to improve this, you need to do the following:

1) Add a userspace daemon that uses vmchannel that runs in the guest and 
can fetch kallsyms and arbitrary modules.  If that daemon lives in 
tools/perf, that's fine.
2) Add a QMP interface in qemu to interact with such daemon
3) Add a default QMP port in a well known location[1]
4) Modify the perf tool to look for a default QMP port.  In the case of 
a single guest, there's one port.  If there are multiple guests, then 
you will have to connect to each port, find the name or any other 
identifying information, and let the user choose.

Patches are certainly welcome.

[1] I've written up this patch and will send it out some time today.

Regards,

Anthony Liguori

