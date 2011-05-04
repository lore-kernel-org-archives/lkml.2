Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1EDMvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:51:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60733 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1EDMvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H1TCdIbtSfX07rtNLsVa2/2q7n0H7yptgoZc6Fy2pQfi6qUBEfRDi24C2yTW5TL7LV
         PT7ABKFrbsvJI0SFkSshNpunUeTRRyRVg+b+U/dIumd9PrJNn3gHvgtE36WRd0aSME1f
         bpBznMvTsAo9EQ/Dhe9MyASDYlMGYV8qn+/7Q=
MIME-Version: 1.0
In-Reply-To: <20110504112746.GE8007@htj.dyndns.org>
References: <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
	<web-516990066@zbackend1.aha.ru>
	<BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
	<20110503190822.GA20520@elte.hu>
	<BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
	<20110504083559.GB25724@elte.hu>
	<alpine.LFD.2.02.1105041124080.3005@ionos>
	<20110504101932.GA3392@elte.hu>
	<alpine.LFD.2.02.1105041233280.3005@ionos>
	<BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
	<20110504112746.GE8007@htj.dyndns.org>
Date: Wed, 4 May 2011 15:51:14 +0300
X-Google-Sender-Auth: Oqnbf0_NO7x65VeJc61WrdpzF5s
Message-ID: <BANLkTikKZhqkcrG8aqUD0tJxZE5zVu0pMg@mail.gmail.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
From: Pekka Enberg <penberg@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, May 4, 2011 at 2:27 PM, Tejun Heo <tj@kernel.org> wrote:
> Hmmm... if it's a race caused by preemtion enabled where it shouldn't
> be, it's most likely the wrong type of this_cpu_cmpxchg_double() being
> used in SLUB?  ie. __this_cpu_cmpxchg_double() where it should have
> been this_cpu_cmpxchg_double()?  Christoph?

There's no __this_cpu_cmpxchg_double() usage in mm/slub.c so I don't
think it's that simple.
