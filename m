Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1LUIGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:06:10 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39084 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363Ab1LUIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:06:08 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1112201016380.21231@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
	<CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com>
	<CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
	<alpine.DEB.2.00.1112201016380.21231@router.home>
Date: Wed, 21 Dec 2011 10:06:07 +0200
X-Google-Sender-Auth: nfqmD1CgHh8Mt6RSsMw2Pw1hmjs
Message-ID: <CAOJsxLGj+y2UygJLQO4xbxqgY5OcU65RBZg-P7yecNgc6fKZjQ@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Pekka Enberg wrote:
>> To illustrate the issue, for "per cpu add" we have:
>>
>> __this_cpu_add()
>> this_cpu_add()
>> irqsafe_cpu_add()
>> percpu_add()
>>
>> Why do we need all of them?

On Tue, Dec 20, 2011 at 6:26 PM, Christoph Lameter <cl@linux.com> wrote:
> These are all operations that frequently occur in hot paths of the OS.

It's a provably difficult API to use that has pretty much zero
debugging code. That's a problem.

I still don't understand why we'd want separate preempt safe and
irqsafe variants. It should be enough to have only unsafe and safe
variants where the latter would always do the right thing.

                                Pekka
