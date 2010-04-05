Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0DEOoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 10:44:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45794 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab0DEOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 10:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wj35M8O60UAsiI0Yz3oxFGwSg7pwLi0DibXJSVrNdNyht1PtvexPB1qcSLHjct706q
         0fiVwOM3bh1j1FbxfZ1l8+aclbziXBBRxszjmsRLansE1m2j+EY8c4OCNE1xBGmBnw2Z
         Ydpw/7ocIZGSXTzqR9AKtibtQDy6u5FN6VxzA=
MIME-Version: 1.0
In-Reply-To: <1270195184.5109.523.camel@twins>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
	 <20100401122740.a1ae80a7.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain>
	 <h2s40ec3ea41004011300zaa5699f0kcf07434fec9b1aab@mail.gmail.com>
	 <alpine.LFD.2.00.1004012203270.32352@localhost.localdomain>
	 <1270195184.5109.523.camel@twins>
Date: Mon, 5 Apr 2010 10:44:46 -0400
X-Google-Sender-Auth: d8e7a0725cacb65f
Message-ID: <v2s40ec3ea41004050744i9ced0c7fpff58b582b2e685af@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till 
	after load update period
From: Chase Douglas <chase.douglas@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 3:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-04-01 at 22:18 +0200, Thomas Gleixner wrote:
>> Well, the uninterruptible count imbalance is preventing us to calc the
>> load avg per cpu, which is something the power saving folks are
>> interested in.
>>
>> If that is fixed we probably have a good chance to collect the per cpu
>> stuff and build a combined one - have not looked into the gory details
>> of the math yet.
>
> The problem with all this per-cpu loadavg is that it would require a
> steady tick on each cpu to age this loadavg, which is quite in
> contradiction with power savings as they rather like the nohz feature.
>
> No idea yet on what to do about that.

What if we stored the time at which a cpu goes idle in its rq. Then,
when the time comes around to calculate the load avg one cpu should be
able to scan the run queues of all the cpus and use their load avg if
not idle, or use their load avg + idle timestamp math if idle.

-- Chase
