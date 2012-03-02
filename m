Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2CBAiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:38:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49977 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab2CBAit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:38:49 -0500
X-IronPort-AV: E=Sophos;i="4.73,514,1325433600"; 
   d="scan'208";a="4428392"
Message-ID: <4F5016E8.9090206@cn.fujitsu.com>
Date: Fri, 02 Mar 2012 08:40:08 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [PATCH]qemu: deal with guest paniced event
References: <4F4AF1FB.6000903@cn.fujitsu.com>	<4F4AF316.50400@cn.fujitsu.com> <20120301135139.5f2b2a5c@doriath.home>
In-Reply-To: <20120301135139.5f2b2a5c@doriath.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-02 08:36:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-02 08:36:58,
	Serialize complete at 2012-03-02 08:36:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/02/2012 12:51 AM, Luiz Capitulino Wrote:
> On Mon, 27 Feb 2012 11:05:58 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> When the host knows the guest is paniced, it will set
>> exit_reason to KVM_EXIT_GUEST_PANIC. So if qemu receive
>> this exit_reason, we can send a event to tell management
>> application that the guest is paniced.
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  kvm-all.c                 |    3 +++
>>  linux-headers/linux/kvm.h |    1 +
>>  monitor.c                 |    3 +++
>>  monitor.h                 |    1 +
>>  4 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/kvm-all.c b/kvm-all.c
>> index c4babda..ae428ab 100644
>> --- a/kvm-all.c
>> +++ b/kvm-all.c
>> @@ -1190,6 +1190,9 @@ int kvm_cpu_exec(CPUState *env)
>>                      (uint64_t)run->hw.hardware_exit_reason);
>>              ret = -1;
>>              break;
>> +        case KVM_EXIT_GUEST_PANIC:
>> +            monitor_protocol_event(QEVENT_GUEST_PANICED, NULL);
>> +            break;
> 
> The event alone is not enough, because the mngt app may miss it (eg. the panic
> happens before the mngt app connected to qemu).
> 
> A simple way to solve this would be to also add a new RunState called
> guest-panic and make the transition to it (besides sending the event).
> 
> A more general way would be to model this after -drive's werror/rerror options,
> say guest-error=report|ignore|stop. When guest-error=stop, the mngt app will
> get a STOP event and can check the VM runstate to know if it's guest-panic.

OK, I will fix it.

Thanks
Wen Congyang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

