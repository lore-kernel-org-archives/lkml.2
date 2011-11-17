Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1KQTNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:13:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52053 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab1KQTNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:13:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111117184200.GA5037@www.outflux.net>
References: <20111117184200.GA5037@www.outflux.net>
Date: Thu, 17 Nov 2011 11:13:22 -0800
Message-ID: <CA+8MBb+SEF_0ORtbHq+ZpxQyE=WTVrGCPoY7ZH1zCDD8zoJ=Zg@mail.gmail.com>
Subject: Re: [PATCH] pstore: gracefully handle NULL pstore_info functions
From: Tony Luck <tony.luck@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>, Don Zickus <dzickus@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 10:42 AM, Kees Cook <keescook@chromium.org> wrote:
> -       kmsg_dump_register(&pstore_dumper);
> +       if (psi->write && psi->buf && psi->bufsize)
> +               kmsg_dump_register(&pstore_dumper);

I can see that you might not need the other parts of the pstore
interface if your back-end is very simple (e.g. only has space for a
single record). But stub functions are cheap - so it isn't clear who
should pay the overhead.

BUT - without psi->write!? What use is it!?  I think in an early version
I refused the registration with -EINVAL - but akpm convinced me it
was a waste of electrons:

On Wed, 1 Dec 2010 16:51:39 Andrew Morton <akpm@linux-foundation.org> wrote:
>> +     if (!psi->reader || !psi->writer || !psi->eraser) {
>> +             spin_unlock(&pstore_lock);
>> +             return -EINVAL;
>
> It doesn't seem appropriate to check this here.  It's a programming
> error!  Just install the thing and let the kernel oops - the programmer
> will notice.

Hiding the lack of a ->write function by quietly accepting the registration, but
not hooking into kmsg_dump doesn't sound useful in any scenario.

-Tony

Dang - pstore is coming up on a year old - time flies when you're having fun.
