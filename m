Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1HTRcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 13:32:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58415 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1HTRcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 13:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <1313829403.19751.14.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
 <1313772419-21951-8-git-send-email-matt@console-pimps.org>
 <CAMjpGUcwkLkHo33WY1vJr4pWPz9wgVcwti5nuqLM2FQYWn6O=A@mail.gmail.com> <1313829403.19751.14.camel@mfleming-mobl1.ger.corp.intel.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 20 Aug 2011 13:31:50 -0400
X-Google-Sender-Auth: QfYi5W1xw4gQdRAeulANFwD2K3I
Message-ID: <CAMjpGUexVttx_tnjsL5i9NfF2bTjH5y9H5eLosFQw0Nq12+JoQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/43] blackfin: Use set_current_blocked() and block_sigmask()
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 04:36, Matt Fleming wrote:
> On Sat, 2011-08-20 at 00:00 -0400, Mike Frysinger wrote:
>> On Fri, Aug 19, 2011 at 12:46, Matt Fleming wrote:
>> > --- a/arch/blackfin/kernel/signal.c
>> > +++ b/arch/blackfin/kernel/signal.c
>> > -       if (ret == 0) {
>> > -               spin_lock_irq(&current->sighand->siglock);
>> > -               sigorsets(&current->blocked, &current->blocked,
>> > -                         &ka->sa.sa_mask);
>> > -               if (!(ka->sa.sa_flags & SA_NODEFER))
>> > -                       sigaddset(&current->blocked, sig);
>> > -               recalc_sigpending();
>> > -               spin_unlock_irq(&current->sighand->siglock);
>> > -       }
>> > +       if (ret == 0)
>> > +               block_sigmask(ka, sig);
>>
>> the Blackfin version holds siglock and calls recalc_sigpending() while
>> block_sigmask() does neither.  i'm guessing that is expected behavior
>> now ?
>
> Yah, set_current_blocked() inside of block_sigmask() still grabs siglock
> and calls recalc_sigpending() for you. Reading current->blocked inside
> of block_sigmask() is fine and the sigorsets() is OK because we're
> modifying a stack variable, so only grabbing the lock inside of
> set_current_blocked() is safe.

thanks for clearing that up (and the code itself!).

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
