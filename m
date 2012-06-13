Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab2FMHjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:39:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59360 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab2FMHjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:39:16 -0400
X-IronPort-AV: E=Sophos;i="4.77,402,1336320000"; 
   d="scan'208";a="5177171"
Message-ID: <4FD83B20.9060203@cn.fujitsu.com>
Date: Wed, 13 Jun 2012 15:02:56 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 3/3] deal with guest panicked event
References: <4FB9E4CE.8060709@cn.fujitsu.com> <4FB9E5CB.2020208@cn.fujitsu.com> <4FD74447.2090906@redhat.com>
In-Reply-To: <4FD74447.2090906@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/13 14:59:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/13 14:59:26,
	Serialize complete at 2012/06/13 14:59:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 06/12/2012 09:29 PM, Paolo Bonzini Wrote:
> Il 21/05/2012 08:50, Wen Congyang ha scritto:
>> +DEF("onpanic", HAS_ARG, QEMU_OPTION_onpanic, \
>> +    "-onpanic report|pause|quit\n" \
>> +    "                action when the guest is panicked [default=report]",
>> +    QEMU_ARCH_ALL)
>> +STEXI
>> +@item -onpanic @var{action}
>> +
>> +The @var{action} controls what QEmu will do when the guest is panicked.
>> +The default is @code{report} (emit QEVENT_GUEST_PANICKED only).
> 
> -watchdog-action just calls this "none".

Yes, I will change the action name.

> 
>> +Other possible actions are:
>> +@code{pause} (emit QEVENT_GUEST_PANICKED and pause VM),
>> +@code{quit} (emit QEVENT_GUEST_PANICKED and quit VM).
> 
> Rather than just "quit", there should be choices for "shutdown",
> "poweroff" and "reset" for consistency with -watchdog-action.

Hmm, quit means poweroff. I will add reset, but I think we donot
need shutdown, because we cannot shutdown the system when it is
panicked.

> 
> Also, this option should also be accessible from "-machine", please.

I don't understand this. Do you mean we can also specify this action
in -machine option?

Thanks
Wen Congyang

> 
> Paolo
> 
>> +ETEXI
>> +
>>  HXCOMM This is the last statement. Insert new options before this line!
>>  STEXI
>>  @end table
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

