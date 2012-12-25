Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2LYPng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 10:43:36 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30520 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab2LYPnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 10:43:33 -0500
Message-ID: <50D9C8E9.6020602@parallels.com>
Date: Tue, 25 Dec 2012 19:40:25 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Wagin <avagin@gmail.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/4] signalfd: add ability to return siginfo in a raw
 format
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-2-git-send-email-avagin@openvz.org> <20121224165306.GA9553@redhat.com> <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com> <20121225143043.GA1813@redhat.com> <20121225152716.GA3198@redhat.com>
In-Reply-To: <20121225152716.GA3198@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 07:27 PM, Oleg Nesterov wrote:
> On 12/25, Oleg Nesterov wrote:
>>
>> And if we add another format we should think
>> twice.
> 
> And btw this applies to the whole series.
> 
> I guess that probably you actually need DUMP, not DEQUEUE. but the
> latter is not trivial. However, perhaps we can do this assuming that
> all other threads are sleeping and nobody can do dequeue_signal().
> Say, we can play with ppos/llseek. If *ppos is not zero,
> signalfd_dequeue() could dump the nth entry from list or return 0.

This would be perfect, but isn't it better to preserve the pos
semantics -- we do know size of entry we're about to copy, we can
treat pos as offset in bytes, not in elements.

> Oleg.
> 
> .
> 


