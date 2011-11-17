Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1KQQ7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:59:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446Ab1KQQ7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:59:48 -0500
Date: Thu, 17 Nov 2011 11:59:39 -0500
From: Jason Baron <jbaron@redhat.com>
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Randy Dunlap <rdunlap@xenotime.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/5] x86: check stack overflows more reliably
Message-ID: <20111117165938.GA2441@redhat.com>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
 <CAOJsxLGH6maRZPx0TX4r6Zy=AiXQMRssoySeOmjn02O-BkBDEA@mail.gmail.com>
 <4EB8DB84.6070300@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB8DB84.6070300@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:34:28PM +0900, HAYASAKA Mitsuo wrote:
> Hi Pekka,
> 
> Thank you for your comments.
> 
> (2011/11/07 16:00), Pekka Enberg wrote:
> > On Mon, Nov 7, 2011 at 7:51 AM, Mitsuo Hayasaka
> > <mitsuo.hayasaka.hu@hitachi.com> wrote:
> >> (2) check stack overflow in detail
> >>    Currently, only kernel stack is checked for the overflow,
> >>    which is not sufficient for enterprise systems. To enhance
> >>    reliability, expand stack overflow checking to IRQ and
> >>    exception stacks optionally. This is disabled by default
> >>    in Kconfig.
> > 
> > This sounds useful. What's the reason for not enabling this by
> > default? Performance regressions?
> 
> I'm worried about performance regressions because this patch checks 
> a stack overflow in detail.
> 
> However, I guess there is no problem for enabling it by default 
> since this option is for debug and appears only if a DEBUG_STACKOVERFLOW
> option is enabled.
> 
> So, I'd like to send the revised patch if it does not have any further problem.
> 
> 

Another thought might be to make stack_overflow_check() depend on a jump
label. Its not something that going to be switch on/off often, and then perhaps
we wouldn't even need DEBUG_STACKOVERFLOW...It seems like a good
use-case to me.

Thanks,

-Jason
