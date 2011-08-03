Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1HCUsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:48:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34131 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1HCUs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:48:27 -0400
MIME-Version: 1.0
In-Reply-To: <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
	<201105171050.38903.florian@openwrt.org>
	<37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk>
	<201107061815.36294.florian@openwrt.org>
	<5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk>
Date: Wed, 3 Aug 2011 23:48:26 +0300
X-Google-Sender-Auth: jj5GN0XlIIhDwQ2WddwtbS9NkBU
Message-ID: <CAOJsxLFSdPO2ebjM9W9JaNcX80COzn=Y3hFukXZjn+1yY4ivZQ@mail.gmail.com>
Subject: Re: RFC: [Restatement] KBUS messaging subsystem
From: Pekka Enberg <penberg@kernel.org>
To: Tony Ibbs <tibs@tonyibbs.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Your description doesn't really explain what you want to use this
thing exactly for in userspace.

On Fri, Jul 29, 2011 at 12:48 AM, Tony Ibbs <tibs@tonyibbs.co.uk> wrote:
> So why did we write it as a kernel module?
> ==========================================
> As implementors, a kernel module makes a lot of sense. Not least
> because:
>
> * It gives us a lot of things for free, including list handling,
>  reference counting, thread safety and (on larger systems)
>  multi-processor support, which we would otherwise have to write and
>  debug ourselves. This also keeps our codebase smaller.

That's not a reason to put this into the kernel, really.

> * It helps give us reliability, partly because of the code we're
>  relying on, partly because of the strictures of working in the
>  kernel, partly by shielding us from userspace.

So now instead of crashing in userspace, we crash the kernel? This
seems like a bogus argument as well.

> * It reduces message copying (we have userspace to kernel back to
>  userspace, as opposed to a userspace daemon communicating with
>  clients via sockets)

Now this sounds like a real reason but you'd have to explain why you
can't reuse existing zero-copy mechanisms like splice() and tee().

> * It makes it simple for us to tell when a message recipient has "gone
>  away", as the kernel will call our "release" callback for us.

Again, sounds like a reasonable technical requirement but doesn't
really justify putting all this code into the kernel.

> * It allows us to provide the functionality on systems without
>  requiring anything much beyond /dev and maybe /proc in userspace.

Why is this important?

                                Pekka
