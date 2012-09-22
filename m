Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2IVS5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 14:57:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33628 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2IVS5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 14:57:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120922005905.GA8335@digium.com>
References: <CA+55aFxMmqG32dJXhUe7N+aS=M1q_5hf7iTfsnPKDU4d610EoQ@mail.gmail.com>
 <20120922005905.GA8335@digium.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 Sep 2012 11:57:23 -0700
X-Google-Sender-Auth: aNgiCatdNklWHdbBEJGLtEv5hoY
Message-ID: <CA+55aFzCzF5DZvR6i=Jg+0abSzN_nbAVr7Ef1dzmR3_NNLWmfw@mail.gmail.com>
Subject: Re: Linux 3.6-rc6
To: Shaun Ruffell <sruffell@digium.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>, linux-edac@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 5:59 PM, Shaun Ruffell <sruffell@digium.com> wrote:
>
> I posted patches [1,2,3] that resolve the issue for me. Shaohui Xie
> also hit the issue and posted a slightly different patch [4]. The
> patches are currently waiting for Mauro, who I understand is
> catching up since returning from San Diego, to check them out.
>
> [1] http://marc.info/?l=linux-kernel&m=134764595921752&w=2
> [2] http://marc.info/?l=linux-kernel&m=134764594721747&w=2
> [3] http://marc.info/?l=linux-kernel&m=134764597921761&w=2
> [4] http://marc.info/?l=linux-kernel&m=134753579818528&w=2

That first patch needs a sign-off from you, since you are passing on
somebody elses patch.

Looking at that patch, the patch seems to be a memory leak (?) leaking
the "channels" allocation, along with fixing an odd and incorrect
kfree (and access) of mci->csrows[i]. If that is correct, please write
a proper changelog. The current changelog for that thing is totally
pointless, and doesn't actually explain what the patch *does*.

I'd also like some ack's from people, and I'd love to know which
commit introduced the problem(s). If this problem is new to 3.6, I
want to know what caused it, and if it is *not* new, then the thing
needs to be marked for stable. Please?

Finally, if I'm supposed to apply patches, I really *really* want to
see the patches sent to me explicitly, instead of having people post
pointers to them on the web. I don't apply random stuff on the web, I
want the "please take this patch" to be a case of people *explicitly*
sending it to me with the proper sign-offs in place etc.

IOW, the "hey, you should apply that random patch that wasn't even
sent to you" approach is not something I accept.

                   Linus
