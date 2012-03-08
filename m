Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2CHKKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:10:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45659 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab2CHKKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:10:06 -0500
X-IronPort-AV: E=Sophos;i="4.73,551,1325433600"; 
   d="scan'208";a="4490087"
Message-ID: <4F5885E2.8060701@cn.fujitsu.com>
Date: Thu, 08 Mar 2012 18:11:46 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 2/2 v3] deal with guest panicked event
References: <4F58664D.1070800@cn.fujitsu.com> <4F5868C4.2090509@cn.fujitsu.com> <4F588504.5010205@siemens.com>
In-Reply-To: <4F588504.5010205@siemens.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 18:08:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-08 18:08:08,
	Serialize complete at 2012-03-08 18:08:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/08/2012 06:08 PM, Jan Kiszka Wrote:
> On 2012-03-08 09:07, Wen Congyang wrote:
>> When the host knows the guest is panicked, it will set
>> exit_reason to KVM_EXIT_GUEST_PANICKED. So if qemu receive
>> this exit_reason, we can send a event to tell management
>> application that the guest is panicked and set the guest
>> status to RUN_STATE_PANICKED.
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  kvm-all.c        |    4 ++++
>>  monitor.c        |    3 +++
>>  monitor.h        |    1 +
>>  qapi-schema.json |    2 +-
>>  qmp.c            |    3 ++-
>>  vl.c             |    1 +
>>  6 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/kvm-all.c b/kvm-all.c
>> index 77eadf6..01062af 100644
>> --- a/kvm-all.c
>> +++ b/kvm-all.c
>> @@ -1290,6 +1290,10 @@ int kvm_cpu_exec(CPUState *env)
>>                      (uint64_t)run->hw.hardware_exit_reason);
>>              ret = -1;
>>              break;
>> +        case KVM_EXIT_GUEST_PANICKED:
>> +            monitor_protocol_event(QEVENT_GUEST_PANICKED, NULL);
>> +            vm_stop(RUN_STATE_PANICKED);
>> +            break;
> 
> You're still lacking "ret = -1;".

Sorry, I forgot it...

Thanks
Wen Congyang

> 
> Jan
> 

