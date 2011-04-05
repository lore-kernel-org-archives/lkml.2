Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1DEQqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:46:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab1DEQqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:46:20 -0400
Date: Tue, 5 Apr 2011 18:45:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110405164557.GA23248@redhat.com>
References: <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru> <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9B4265.6080403@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Stas Sergeev wrote:
>
> 05.04.2011 19:15, Oleg Nesterov wrote:
>>>
>>> +			p->detaching = 0;
>>> +			continue;
>> Yes, thanks, I didn't notice "continue". But then this is wrong again.
>> This can race with wait_task_detached() called by our sub-thread, it
>> can clear ->detaching before we check it.
> But the above code is under write_lock_irq(&tasklist_lock), so why
> would it race?

wait_task_detached() clears detaching, then it drops tasklist and takes
it for writing. forget_original_parent() can come in between.

Oleg.

