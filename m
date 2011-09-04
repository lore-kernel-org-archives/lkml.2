Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1IDTHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 15:07:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35068 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1IDTHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 15:07:46 -0400
Message-ID: <e3b9f4c07ac1f801dbbafe54aea43116.squirrel@www.firstfloor.org>
In-Reply-To: <20110904165658.GA23948@redhat.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
    <1314661157-22173-4-git-send-email-andi@firstfloor.org>
    <alpine.LFD.2.02.1109021135270.2723@ionos>
    <20110904165658.GA23948@redhat.com>
Date: Sun, 4 Sep 2011 21:07:43 +0200
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
From: "Andi Kleen" <andi@firstfloor.org>
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <andi@firstfloor.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        "Andi Kleen" <ak@linux.intel.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> And why do we need to add signal->idr_lock ? It is only used to
> serialize idr_get/idr_remove. Probably we can use ->siglock for that,
> posix timers use this lock anyway.

Ok. In fact idrs have an own lock too, I'll check that out.

>
> Also. I am not sure, but perhaps it make sense to turn
> signal->posix_timers_id into the pointer to "struct idr" and allocate
> idr on demand?

Probably not worth it, it's not big enough.

-Andi

