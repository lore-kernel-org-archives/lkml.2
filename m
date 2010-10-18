Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0JRMTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 08:19:30 -0400
Received: from bohort.kerlabs.com ([90.80.97.101]:46041 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab0JRMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 08:19:29 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Oct 2010 08:19:29 EDT
Message-ID: <4CBC3A17.2080306@kerlabs.com>
Date: Mon, 18 Oct 2010 14:14:15 +0200
From: =?ISO-8859-15?Q?Matthieu_Fertr=E9?= <matthieu.fertre@kerlabs.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Louis Rilling <louis.rilling@kerlabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Darren Hart <darren@dvhart.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RESEND PATCH] futex: fix key reference counter in case of	requeue.
References: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com> <alpine.LFD.2.00.1010151228130.2496@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010151228130.2496@localhost6.localdomain6>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/10/2010 14:16, Thomas Gleixner a écrit :
> On Thu, 14 Oct 2010, Louis Rilling wrote:
> 
>> From: Matthieu Fertré <matthieu.fertre@kerlabs.com>
>>
>> This patch ensures that we are referring to the right key when dropping
>> reference for the futex_wait operation.
>>
>> The following scenario explains a typical case where the bug was
>> happening:
>>
>> Process P calls futex_wait() on futex identified by 'key1'. 2 references
>> are taken on this key: one for the struct futex_q itself, and one for the
>> futex_wait operation.
> 
> It took a while to understand that explanation. You mean we get one
> ref in get_key_ref() and one in queue_lock(), right ?
> 

That's it. Sorry for the unclear explanation.

Regards,

Matthieu
