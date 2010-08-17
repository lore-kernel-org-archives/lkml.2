Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0HQDRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 23:17:08 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53450 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab0HQDRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 23:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=szsib2vrStwoUdRdlgoSbyLODnYWnbXp0bPzMdaFWFlrBO4ifSMDbjpcl6XKabV1sw
         6aeO1v4EATwu7KjqKWAy1kTi8/cb0VY+bKRz8Pkiv8LQJEWWJM92M8bz6oFSYx3mdhG8
         BKoSLx7bp+46WWbHxSokwijyMwLCCSpws2MCg=
MIME-Version: 1.0
In-Reply-To: <20100817025954.GA12366@nowhere>
References: <20100813102158.GA5434@swordfish.minsk.epam.com>
	<1281946970.1926.998.camel@laptop>
	<20100816133452.GS4879@redhat.com>
	<1281966418.1926.1421.camel@laptop>
	<20100816140829.GA5225@swordfish.minsk.epam.com>
	<20100817025954.GA12366@nowhere>
Date: Tue, 17 Aug 2010 11:16:29 +0800
Message-ID: <AANLkTikdng247Fct0ANXiitC3ja98_ee3-fUVDGraEwo@mail.gmail.com>
Subject: Re: [PATCH] fix BUG using smp_processor_id() in touch_nmi_watchdog
 and touch_softlockup_watchdog
From: Yong Zhang <yong.zhang0@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:59 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> If preemption is disabled and you deal with the current cpu,
> then please use __get_cpu_var, it makes the code more
> readable:
>
>
> void touch_softlockup_watchdog(void)
> {
>        preempt_disable();
>        __(watchdog_touch_ts) = 0;
>        preempt_enable();
> }

Why not use __raw_get_cpu_var() instead?
You know adding preempt protection in touch_softlockup_watchdog()
just suppress the warning. Am I missing something?

Thanks,
Yong
