Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2IMJ7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab2IMJ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:59:45 -0400
Message-ID: <5051AE8B.7090904@redhat.com>
Date: Thu, 13 Sep 2012 12:59:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: qemu-kvm loops after kernel udpate
References: <504F7ED8.1030702@suse.cz> <20120911190303.GA3626@amt.cnet> <504F93F1.2060005@suse.cz> <50504299.2050205@redhat.com> <50504439.3050700@suse.cz> <5050453B.6040702@redhat.com> <5050D048.4010704@suse.cz>
In-Reply-To: <5050D048.4010704@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 09:11 PM, Jiri Slaby wrote:
> On 09/12/2012 10:18 AM, Avi Kivity wrote:
>> On 09/12/2012 11:13 AM, Jiri Slaby wrote:
>>>
>>>>  Please provide the output of vmxcap
>>>> (http://goo.gl/c5lUO),
>>>
>>>   Unrestricted guest                       no
>> 
>> The big real mode fixes.
>> 
>> 
>>>
>>>> and a snapshot of kvm_stat while the guest is hung.
>>>
>>> kvm statistics
>>>
>>>  exits                                      6778198  615942
>>>  host_state_reload                             1988     187
>>>  irq_exits                                     1523     138
>>>  mmu_cache_miss                                   4       0
>>>  fpu_reload                                       1       0
>> 
>> Please run this as root so we get the tracepoint based output; and press
>> 'x' when it's running so we get more detailed output.
> 
> kvm statistics
> 
>  kvm_exit                                  13798699  330708
>  kvm_entry                                 13799110  330708
>  kvm_page_fault                            13793650  330604
>  kvm_exit(EXCEPTION_NMI)                    6188458  330604
>  kvm_exit(EXTERNAL_INTERRUPT)                  2169     105
>  kvm_exit(TPR_BELOW_THRESHOLD)                   82       0
>  kvm_exit(IO_INSTRUCTION)                         6       0

Strange, it's unable to fault in the very first page.

Please provide a trace as per http://www.linux-kvm.org/page/Tracing (but
append -e kvmmmu to the command line).



-- 
error compiling committee.c: too many arguments to function
