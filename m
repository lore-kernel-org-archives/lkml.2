Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2DJJGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:06:16 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:41245 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab2DJJGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:06:15 -0400
Message-ID: <4F83F7EF.4030700@parallels.com>
Date: Tue, 10 Apr 2012 13:05:51 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "criu@openvz.org" <criu@openvz.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Subject: Re: [CRIU] [PATCH 2/4] ipc: move all checkpoint-restore code under
 appropriate define
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6> <20120409175404.8358.32321.stgit@localhost6.localdomain6> <4F833CDF.4080300@parallels.com>
In-Reply-To: <4F833CDF.4080300@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.04.2012 23:47, Pavel Emelyanov пишет:
> On 04/09/2012 09:54 PM, Stanislav Kinsbursky wrote:
>> All new checkpoint/restore code parts are now covered with
>> CONFIG_CHECKPOINT_RESTORE marco. So it would be easy to remove them, in case
>> the whole project fails.
>>
>> ---
>>   ipc/compat.c |    9 ++++++---
>>   ipc/msg.c    |   15 ++++++++++++++-
>>   2 files changed, 20 insertions(+), 4 deletions(-)
>>
>> @@ -387,8 +388,10 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
>>   		msgtyp = ipck.msgtyp;
>>   	}
>>   	return do_msgrcv(first, uptr, second, msgtyp, third,
>> -			 (third&  MSG_PEEK_ALL) ? compat_do_msg_peek_all
>> -						: compat_do_msg_fill);
>> +#ifdef CONFIG_CHECKPOINT_RESTORE
>> +			 (third&  MSG_PEEK_ALL) ? compat_do_msg_peek_all :
>> +#endif
>> +						compat_do_msg_fill);
>
> These ifdefs in the middle of the code look not very elegant. Is there a way
> to replace the checks they surround with static inline function (reporting
> 0 when CHECKPOINT_RESTORE is off) potentially letting the compiler optimize
> out the code sitting under if (0) ?
>

Yes, sure. I'll do this.

-- 
Best regards,
Stanislav Kinsbursky
