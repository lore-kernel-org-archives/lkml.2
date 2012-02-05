Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2BEGxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 01:53:41 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49384 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2BEGxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 01:53:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAMO-S2joH0fwEyOOCSFGM+Lc=xgiarNxm3Rj9DgWJNeoRD+QRQ@mail.gmail.com>
References: <20120121082857.GC32134@elte.hu>
	<CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
	<20120121165830.GA9216@elte.hu>
	<CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
	<CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
	<CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
	<CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
	<20120131115855.5861bad7@pyramind.ukuu.org.uk>
	<20120131120922.GD32010@elte.hu>
	<20120131121820.58a1db97@pyramind.ukuu.org.uk>
	<20120131122339.GG32010@elte.hu>
	<CA+55aFw4F-02NxbQHmpy0KtXxKc9++HutgVXd7nGe0G7NqG+Gw@mail.gmail.com>
	<1328144756.2768.57.camel@dabdike.int.hansenpartnership.com>
	<4F2AA642.1030400@linux.intel.com>
	<CAMO-S2joH0fwEyOOCSFGM+Lc=xgiarNxm3Rj9DgWJNeoRD+QRQ@mail.gmail.com>
Date: Sun, 5 Feb 2012 07:53:39 +0100
X-Google-Sender-Auth: A3Od6HM0Vxs-wdyHa_YQKeAuAjk
Message-ID: <CAMuHMdXvv_fvaUq_64_kOHCJ4+04uM_iw7aYxwOPU-Tg+g00-A@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        James Bottomley <jbottomley@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 16:39, Hitoshi Mitake <h.mitake@gmail.com> wrote:
>> I worked myself on a driver (which sadly never shipped) which had an WC
>> window and a UC window... the final write in a series had a completion bit
>> in it and would go to the UC window after setting up a whole chunk of
>> operations in the WC window (writing UC memory flushes WC memory ahead of
>> it.)
>>
>> Thus, the two-part breakdown of writeq() to the UC window had to write the
>> low half to the WC window instead.  This is clearly not generic.
>
> Because of my ignorant, I don't know the words "UC window" and "WC window"
> in this context. Could you teach me?

UN = uncached, WC = writecombining.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
