Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2IXLN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:13:57 -0400
Received: from science.horizon.com ([71.41.210.146]:58733 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753356Ab2IXLNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:13:54 -0400
Date: 24 Sep 2012 07:13:53 -0400
Message-ID: <20120924111353.27142.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, linux@horizon.com, rabin@rab.in
Subject: Re: [PATCH 3/4] lib: vsprintf: Optimize put_dec_trunc8
Cc: hughd@google.com, linux-kernel@vger.kernel.org, mina86@mina86.com,
        mpn@google.com, vda.linux@googlemail.com
In-Reply-To: <CAH+eYFBscQnH78CZFLq2GwTJZR1+zkUc6gL1QgnWNoFCQwRy2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, joy, a new week and a nice dose of public humiliation to start it off.
(Remind me never to go AFK for a weekend again.)

Seriously, Rabin, thank you very much for the bug report and my
apologies for inflicting the bug on you in the first place.

Denys, good to hear from you.  I had hoped this would be signed off
by you before going upstream, but akpm picked it up first.


This code *was* extensively tested, but in a user-space test harness.
Moving it into the kernel was less so; I looked at a lot of /proc and
/sys files, but known answers are hard to come by there, and I didn't
actually write a complete test module.

(It's also running on the production file/mail server I'm sending
this from; I do eat my own dog food.)

However, thinking back, the sprintf code I used, for comparison with
the libc sprintf, wanted a binary->decimal primitive that converts 0 to
the empty string; getting ANSI compatible results from "%.0u" and "%.1u"
is easier with that convention.

My initial suspicion is that I didn't convert that convention properly
somehow.


Anyway, individual responses to follow.
