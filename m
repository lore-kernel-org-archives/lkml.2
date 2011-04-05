Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1DEQZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:25:16 -0400
Received: from mail.aknet.ru ([78.158.192.28]:36342 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1DEQZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:25:13 -0400
Message-ID: <4D9B4265.6080403@aknet.ru>
Date: Tue, 05 Apr 2011 20:25:09 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com>
In-Reply-To: <20110405151549.GB17490@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.04.2011 19:15, Oleg Nesterov wrote:
> I don't understand the "and not is a child on init's subthread".
> If the child was created by init's sub-thread, it is the child
> of the whole thread group.
>
> ->real_parent points to thread, yes.
OK, sorry, I thought you mean the CLONE_PARENT case, where
the real_parent points _not_ to thread. That's why the confusion.

>   But the parent is the whole
> process, not thread. The only reason for this oddity is __WNOTHREAD.
OK, now I see what problem you are pointing to.
Will fix.

>> How? I think I prevented that with this:
>> ---
>>
>> +			p->detaching = 0;
>> +			continue;
> Yes, thanks, I didn't notice "continue". But then this is wrong again.
> This can race with wait_task_detached() called by our sub-thread, it
> can clear ->detaching before we check it.
But the above code is under write_lock_irq(&tasklist_lock), so why
would it race?
