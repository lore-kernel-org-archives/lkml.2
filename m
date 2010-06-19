Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0FSOHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:07:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54388 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0FSOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gfFKNCKGaaxgWqfFVQ5v0BkcVj/gO3WGJsXX+5fMf0WNON2FcZKWnfmYr6nNzT86lr
         7cQ3R1jU6eArs6NzJFcFBvYHa8qQEo37NEW4+ryh2zMmJqTvEAQjzEoUGq2EhSx2xZu0
         k3V3RR3drf4A57o0UkaBTDMbDD3KuMqtTL5Zs=
MIME-Version: 1.0
In-Reply-To: <20100619105352.GA10186@elte.hu>
References: <20100612102558.GA4000@elte.hu>
	<4C15A5D1.1040104@jp.fujitsu.com>
	<20100618094838.GD23977@elte.hu>
	<AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
	<20100618124551.GC7612@elte.hu>
	<AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
	<20100618143532.GA10886@elte.hu>
	<AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
	<1276875067.1875.133.camel@laptop>
	<20100619080210.GC18946@basil.fritz.box>
	<20100619105352.GA10186@elte.hu>
Date: Sat, 19 Jun 2010 22:07:42 +0800
Message-ID: <AANLkTilyV7XkZCsD5uNGhdTAGUUEvR5xIuvbwQGiMYvP@mail.gmail.com>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, "H.PeterA" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 6:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
> The proper, generic approach would be to enable softirq notifications (on x86)
> from NMI contexts as well (it's actually possible without overhead),

Yes. I will do that. And I think self interrupt can be used as the
short-cut for soft_irq if available. The next soft_irq may be too late
if there is too few interrupts.

> and to
> extend user return notifiers with the logical next step: nmi return notifiers.
> If presented in such a form then those could use softirqs for atomic callbacks
> and per cpu kthreads for sleepable callbacks, etc.

NMI return notifiers fired in soft_irq?

Best Regards,
Huang Ying
