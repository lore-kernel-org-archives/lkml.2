Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab1CUR4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:56:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49018 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1CUR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=itbG9uWx/qOc+pBlWm45cP46d7YgKRGo9MpCUjUtphD4AoqRnjfhrC/0WgzUQnnwC6
         2QCLKl5HbulelHrP2lS++qO3OjAC4ZW+NodtayY9iJdu5DFCou1urtYMZRWc2lm0oX/a
         41lx7OgjupphsM6h1dqHcdzk6yNMJlkV6GVr8=
Message-ID: <4D879109.2040000@gmail.com>
Date: Mon, 21 Mar 2011 20:55:21 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <4D878042.9080708@gmail.com> <4D878445.6090709@gmail.com> <20110321170832.GC12718@sgi.com> <4D87888D.4050400@gmail.com> <20110321173413.GA13916@sgi.com> <4D878F7A.7070506@gmail.com>
In-Reply-To: <4D878F7A.7070506@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 08:48 PM, Cyrill Gorcunov wrote:
...
>>>   Another option might be to add pre-nmi notifier chain, which of course
>>> not much differ from platform ops but I guess platform ops stands mostly
>>> for one-shot events while chain might be more flexible. Ie I mean something
>>> like
>>>
>>> 	if (notify_pre_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
>>> 		return;
>>
>> You still need to process both chains in order to handle the case where both
>> hw_perf & the SGI BMC raise NMIs at about the same time.
>>
>> --- jack
> 
> yes, but I meant to simply call this chain before the regular notify_die. Anyway
> it would look ugly as hell too.
> 

And if I'm not missing something kgdb still might call IPI inside NMI handler
which is look somehow strange to me...

-- 
    Cyrill
