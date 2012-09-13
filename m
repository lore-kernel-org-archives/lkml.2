Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2IMScN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:32:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48702 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab2IMScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:32:10 -0400
Message-ID: <505226A5.1030809@suse.cz>
Date: Thu, 13 Sep 2012 20:32:05 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: qemu-kvm loops after kernel udpate
References: <504F7ED8.1030702@suse.cz> <20120911190303.GA3626@amt.cnet> <504F93F1.2060005@suse.cz> <50504299.2050205@redhat.com> <50504439.3050700@suse.cz> <5050453B.6040702@redhat.com> <5050D048.4010704@suse.cz> <5051AE8B.7090904@redhat.com>
In-Reply-To: <5051AE8B.7090904@redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/mixed;
 boundary="------------010206010908050507080000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010206010908050507080000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/13/2012 11:59 AM, Avi Kivity wrote:
> On 09/12/2012 09:11 PM, Jiri Slaby wrote:
>> On 09/12/2012 10:18 AM, Avi Kivity wrote:
>>> On 09/12/2012 11:13 AM, Jiri Slaby wrote:
>>>>
>>>>>  Please provide the output of vmxcap
>>>>> (http://goo.gl/c5lUO),
>>>>
>>>>   Unrestricted guest                       no
>>>
>>> The big real mode fixes.
>>>
>>>
>>>>
>>>>> and a snapshot of kvm_stat while the guest is hung.
>>>>
>>>> kvm statistics
>>>>
>>>>  exits                                      6778198  615942
>>>>  host_state_reload                             1988     187
>>>>  irq_exits                                     1523     138
>>>>  mmu_cache_miss                                   4       0
>>>>  fpu_reload                                       1       0
>>>
>>> Please run this as root so we get the tracepoint based output; and press
>>> 'x' when it's running so we get more detailed output.
>>
>> kvm statistics
>>
>>  kvm_exit                                  13798699  330708
>>  kvm_entry                                 13799110  330708
>>  kvm_page_fault                            13793650  330604
>>  kvm_exit(EXCEPTION_NMI)                    6188458  330604
>>  kvm_exit(EXTERNAL_INTERRUPT)                  2169     105
>>  kvm_exit(TPR_BELOW_THRESHOLD)                   82       0
>>  kvm_exit(IO_INSTRUCTION)                         6       0
> 
> Strange, it's unable to fault in the very first page.
> 
> Please provide a trace as per http://www.linux-kvm.org/page/Tracing (but
> append -e kvmmmu to the command line).

Attached. Does it make sense? It wrote things like:
  failed to read event print fmt for kvm_mmu_unsync_page
to the stderr.

thanks,
-- 
js
suse labs

--------------010206010908050507080000
Content-Type: text/plain; charset=UTF-8;
 name="report"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="report"

version = 6
CPU 0 is empty
cpus=2
        qemu-kvm-6170  [001]   457.811896: kvm_mmu_get_page:     [FAILED TO PARSE] gfn=0 role=122882 root_count=0 unsync=0 created=1
        qemu-kvm-6170  [001]   457.811899: kvm_mmu_get_page:     [FAILED TO PARSE] gfn=262144 role=122882 root_count=0 unsync=0 created=1
        qemu-kvm-6170  [001]   457.811900: kvm_mmu_get_page:     [FAILED TO PARSE] gfn=524288 role=122882 root_count=0 unsync=0 created=1
        qemu-kvm-6170  [001]   457.811902: kvm_mmu_get_page:     [FAILED TO PARSE] gfn=786432 role=122882 root_count=0 unsync=0 created=1
        qemu-kvm-6171  [001]   462.416705: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=786432 role=122882 root_count=1 unsync=0
        qemu-kvm-6171  [001]   462.416712: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=524288 role=122882 root_count=1 unsync=0
        qemu-kvm-6171  [001]   462.416715: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=262144 role=122882 root_count=1 unsync=0
        qemu-kvm-6171  [001]   462.416717: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=0 role=122882 root_count=1 unsync=0
        qemu-kvm-6171  [001]   462.485197: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=0 role=253954 root_count=0 unsync=0
        qemu-kvm-6171  [001]   462.485202: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=262144 role=253954 root_count=0 unsync=0
        qemu-kvm-6171  [001]   462.485205: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=524288 role=253954 root_count=0 unsync=0
        qemu-kvm-6171  [001]   462.485209: kvm_mmu_prepare_zap_page: [FAILED TO PARSE] gfn=786432 role=253954 root_count=0 unsync=0

--------------010206010908050507080000--
