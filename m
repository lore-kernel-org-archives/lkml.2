Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab2BOPCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:02:44 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:7582 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab2BOPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:02:42 -0500
Message-ID: <4F3BC8FC.5000806@parallels.com>
Date: Wed, 15 Feb 2012 19:02:20 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "criu@openvz.org" <criu@openvz.org>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>
Subject: Re: [PATCH] IPC: message queue stealing feature introduced
References: <20120215090711.11586.5396.stgit@localhost6.localdomain6> <1329298813.2437.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1329298813.2437.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.02.2012 13:40, Eric Dumazet пишет:
> Le mercredi 15 février 2012 à 13:08 +0400, Stanislav Kinsbursky a
> écrit :
>> This patch is required for checkpoint/restore in userspace project.
>> C/r requires some way to get all pending IPC messages without deleting them for
>> the queue (checkpoint can fail and in this case tasks will be resumed, so queue
>> have to be valid).
>> To achive this, new operation flag MSG_STEAL for sys_msgrcv() system call
>> introduced.
>> If this flag is set, then passed struct msgbuf pointer will be used for storing
>> array of structures:
>>
>> struct msgbuf_a {
>> 	long mtype;         /* type of message */
>> 	size_t msize;       /* size of message */
>> 	char mtext[0];      /* message text */
>> };
>>
>
> This structure is not 32/64 bit safe and will need compat tricks.
>
> +                       ret = do_steal_msg(mtext, arrsz, msg);
> +                       if (ret<  0) {
> +                               msg = ERR_PTR(ret);
> +                               goto out_unlock;
> +                       }
> +                       mtext += ret + sizeof(struct msgbuf_a);
> +                       arrsz -= ret + sizeof(struct msgbuf_a);
>
> I cant see where alignement requirements are met.
>
> (ret should be rounded up to a multiple of alignof(struct msgbuf_a)
>


Thanks for reply, Eric.
Will fix and resend soon.

-- 
Best regards,
Stanislav Kinsbursky
