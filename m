Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0LDXnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 18:43:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38482 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab0LDXnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 18:43:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pJpb+wPIV3AuiNO9yFaFmmQn3oUeGaP5UIjekuiaw9iKChdBORSXwPxmzWPZReOd+Y
         Yu7sTzY4QVYkeWWP0yoMLsxaXCombQQKGFR5IoGAv2VRrGSX+vYGwS/yYid+L1ZsW1mZ
         G0KW9wEDWMvSZcEUp5RIoDfCCbU51p4v5m3YM=
MIME-Version: 1.0
In-Reply-To: <AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net>
	<1289811438.2109.474.camel@laptop>
	<1289820766.16406.45.camel@maggy.simson.net>
	<1289821590.16406.47.camel@maggy.simson.net>
	<20101115125716.GA22422@redhat.com>
	<1289856350.14719.135.camel@maggy.simson.net>
	<20101116130413.GA29368@redhat.com>
	<1289917109.5169.131.camel@maggy.simson.net>
	<20101116150319.GA3475@redhat.com>
	<1289922108.5169.185.camel@maggy.simson.net>
	<20101116172804.GA9930@elte.hu>
	<1290281700.28711.9.camel@maggy.simson.net>
	<AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
	<AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
	<AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
	<AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com>
Date: Sat, 4 Dec 2010 18:43:44 -0500
X-Google-Sender-Auth: TM4SVri6U8ef8_8UaOd3tg3OEs4
Message-ID: <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Colin Walters <walters@verbum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 4, 2010 at 5:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> And it doesn't hurt you. If you're happy with "nice", go on and use
> it. Why are you even discussing it?

Because it seems to me like a bug if it isn't as good as group
scheduling?  Most of your message is saying it's worthless, and I
don't disagree that it's not very good *right now*.  I guess where we
disagree is whether it's worth fixing.

> What's your point again? It's a heuristic.

So if it's a heuristic the OS can get wrong, wouldn't it be a good
idea to support a way for programs and/or interactive users to
explicitly specify things?  Unfortunately the cgroups utilities don't
make this easy (and of course there's the issue that no major released
OS exports write permission to the cpu cgroup for a desktop session
uid).  I guess "nice" could be patched to, if the user has permission
to the cgroups, to auto-create a group.  Or...nice could be fixed.

On a more productive note, I see now
Documentation/scheduler/sched-nice-design.txt has a lot of really
useful history regarding "nice" and the complaints over time (I guess
this is where some of your assertions that it's failed/worthless comes
from).
