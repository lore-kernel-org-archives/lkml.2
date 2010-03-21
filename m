Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0CUXfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:35:33 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35050 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0CUXfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:35:32 -0400
Message-ID: <4BA6AD3C.4000102@codemonkey.ws>
Date: Sun, 21 Mar 2010 18:35:24 -0500
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
References: <4BA250BF.80704@codemonkey.ws> <20100318162853.GB447@elte.hu> <4BA256FE.5080501@codemonkey.ws> <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com> <20100318170223.GB9756@elte.hu> <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu>
In-Reply-To: <20100321191742.GD25922@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 02:17 PM, Ingo Molnar wrote:
>
>> If you want to improve this, you need to do the following:
>>
>> 1) Add a userspace daemon that uses vmchannel that runs in the guest and can
>>     fetch kallsyms and arbitrary modules.  If that daemon lives in
>>     tools/perf, that's fine.
>>      
> Adding any new daemon to an existing guest is a deployment and usability
> nightmare.
>
> The basic rule of good instrumentation is to be transparent. The moment we
> have to modify the user-space of a guest just to monitor it, the purpose of
> transparent instrumentation is defeated.
>
> That was one of the fundamental usability mistakes of Oprofile.
>
> There is no 'perf' daemon - all the perf functionality is _built in_, and for
> very good reasons. It is one of the main reasons for perf's success as well.
>    

The solution should be a long lived piece of code that runs without 
kernel privileges.  How the code is delivered to the user is a separate 
problem.

If you want to argue that the kernel should build an initramfs that 
contains some things that always should be shipped with the kernel but 
don't need to be within the kernel, I think that's something that's long 
over due.

We could make it a kernel thread, but what's the point?  It's much safer 
for it to be a userspace thread and it doesn't need to interact with the 
kernel in an intimate way.

Regards,

Anthony Liguori

