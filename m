Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab1LUPeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:34:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36120 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1LUPeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:34:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111221151236.GA27571@redhat.com>
References: <20111220221818.GJ10752@google.com>
	<20111221151236.GA27571@redhat.com>
Date: Wed, 21 Dec 2011 07:34:21 -0800
X-Google-Sender-Auth: 01CPKQCEJ6SJ-iaG6bJ8RnU8zJc
Message-ID: <CAOS58YP6ogHaadh1Pjf_jF0+zwecJ7aZjQceisH9xTZ5GTTy4w@mail.gmail.com>
Subject: Re: mempool && io_schedule_timeout()
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Mironchik <tibor0@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 21, 2011 at 7:12 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> +     /*
>> +      * FIXME: this should be io_schedule().  The timeout is there as a
>> +      * workaround for some DM problems in 2.6.18.
>> +      */
>> +     io_schedule_timeout(5*HZ);
>
> Just curious... This was added by 0b1d647a in 2006.
>
> Perhaps the problem was already fixed?

Yeah, I was curious about that too.  It seemed the problem was dm
sharing the same pool from multiple devices (which defeats the purpose
of using mempool BTW).  cc'ing dm devel.  Alasdair, is the problem
fixed now?

Thanks.

-- 
tejun
