Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab1DBWAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 18:00:49 -0400
Received: from mail.aknet.ru ([78.158.192.28]:34633 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114Ab1DBWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 18:00:48 -0400
Message-ID: <4D979C6E.2090503@aknet.ru>
Date: Sun, 03 Apr 2011 02:00:14 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D94BE19.7050001@aknet.ru> <20110331181816.GA17101@redhat.com> <4D94EAEE.2010505@aknet.ru> <20110402135523.GA26316@redhat.com>
In-Reply-To: <20110402135523.GA26316@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.04.2011 17:55, Oleg Nesterov wrote:
>
>>>>   +			if (me->real_parent == init_pid_ns.child_reaper)
>>>   Also, the task can be the child of /sbin/init's sub-thread.
>> Hmm, how to check then? Should I add the "exact_parent" just
>> for that? Or traverse the sibling list? How bad. :(
> You can check same_thread_group(real_parent, ns->child_reaper)
But real_parent==ns->child_reaper in our case, so what does
this check give?

>  acked, I'd try to nack this;)  do_wait() from parent should
>  always work or it should always return ECHLD, but it should
>  not depend on /dev/random. This is really weird, imho.
OK, this can be fixed by delaying the wait() from init till
the old parent wait()s or die. Will fix.

