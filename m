Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2EMNWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 09:22:08 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:4281 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2EMNWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 09:22:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQEDI1YQCxgCAgUhAgIPAkYGDQEHAQG0JIoYgS+OE4EYBKkl
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="179920043"
Message-ID: <4FAFB57C.40906@teksavvy.com>
Date: Sun, 13 May 2012 09:22:04 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sasha Levin <levinsasha928@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com> <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com> <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com> <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com> <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com> <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop> <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com> <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com> <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com> <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com> <CA+1xoqf5YbkOJgQJWOgck0NpqGzGtxtHHJASZKHvwVuBzkKK6A@mail.gmail.com> <CA+55aFyeXdUyj_OzccctFSj1f4su1G8DyxiQwD4W5sV9Dh0Zpg@mail.gmail.com>
In-Reply-To: <CA+55aFyeXdUyj_OzccctFSj1f4su1G8DyxiQwD4W5sV9Dh0Zpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-12 02:35 PM, Linus Torvalds wrote:
>
>  (b) The one thing I have often wanted is not "after how many seconds
> of boot", but "when". So it would actually be nice if the absolute
> time was converted into local time. The kernel can actually do that,
> so I suspect that the best format for the relative timestamps would
> really be something like
> 
>    > [May12 11:27] foo
>    > [May12 11:28] bar
>    > [  +5.077527] zoot
>    > [ +10.235225] foo
>    > [  +0.002971] bar
>    > [May12 11:29] zoot
>    > [  +0.003081] foo
> 
> because that would be really useful sometimes.
> 
> (And no, never mind the year. If you log those things long-term, the
> year will be in the full log, so logging the year in the dmesg is just
> pointless.)
> 
> I dunno. The above is what I would have liked to see quite often. I
> look at dmesg, and notice that I had an WARN_ON_ONCE in it, and I have
> no idea when it happened, because the "seconds since boot" is totally
> useless information for me, as I'm too lazy to try to use /proc/uptime
> to calculate what it is.


Look in syslog ?

