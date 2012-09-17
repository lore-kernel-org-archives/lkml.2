Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2IQUb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:31:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61269 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2IQUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:31:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120823215052.GC19305@somewhere.redhat.com>
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com>
	<CAMuHMdUt62GsYsPMAPbUWZUtFL=c2VmYFintpDAQmSwQrWriuA@mail.gmail.com>
	<20120823110157.GC18835@somewhere.redhat.com>
	<CAMuHMdX5R_7EBGDu00zdy_P3q65BzKJbNeRwFcuwij8eHavTYQ@mail.gmail.com>
	<20120823215052.GC19305@somewhere.redhat.com>
Date: Mon, 17 Sep 2012 22:31:24 +0200
X-Google-Sender-Auth: OSKivg3_AbufzNrHAOvixbsaw-w
Message-ID: <CAMuHMdURT2vdF8uGZbMO09iGbLeSaVzwNthKEA1WwOtH6dQN_A@mail.gmail.com>
Subject: Re: [PATCH 00/10] rcu: Add missing RCU idle APIs on idle loop
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
        "3.2.x.." <stable@kernel.org>, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic, Paul,

On Thu, Aug 23, 2012 at 11:50 PM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> On Thu, Aug 23, 2012 at 10:23:22PM +0200, Geert Uytterhoeven wrote:
>> On Thu, Aug 23, 2012 at 1:02 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Wed, Aug 22, 2012 at 07:18:04PM +0200, Geert Uytterhoeven wrote:
>> >> On Wed, Aug 22, 2012 at 6:23 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >> > So this fixes some potential RCU stalls in a bunch of architectures.
>> >> > When rcu_idle_enter()/rcu_idle_exit() became a requirement, we forgot
>> >> > to handle the architectures that don't support CONFIG_NO_HZ.
>> >> >
>> >> > I guess the set should be dispatched into arch maintainer trees.
>> >>
>> >> I can take the m68k version, but are you sure you want it this way?
>> >> Each of them must be in mainline before they can enter stable.
>> >
>> > Yeah, I was thinking the right route is for these patches to be
>> > carried by arch maintainer who then push to Linus and then this goes
>> > to stable.
>> >
>> > Is that ok for you?
>> >
>> > Otherwise I can carry the patches myself. In a tree of my own, or
>> > Paul's or mmotm. As long as I have your ack.
>>
>> I applied your patch to the m68k for-3.6/for-linus branch.
>> I'll ask Linus to pull later in the rc cycle (right now I don't have
>> anything else
>> queued for 3.6).
>> Still, I think it's better to just collect acks and send it to Linus
>> in one shot,
>> so it can go into stable in one shot too.
>
> Sure I can do that if you prefer.

What's the conclusion on this one? I saw it entered tip.

I still have it (as the only commit) on my for-3.6 branch, but I don't
think m68k
is important enough to be the only architecture to have this fix in 3.6 ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
