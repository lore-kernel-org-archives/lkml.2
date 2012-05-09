Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab2EINaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:30:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59939 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab2EINaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120509070710.GA29981@gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com> <20120509070710.GA29981@gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 9 May 2012 15:29:47 +0200
Message-ID: <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 9:07 AM, Ingo Molnar <mingo@kernel.org> wrote:

> Thanks for bringing sanity into printk,

Just to check all the options we have, and I have no good idea how
they would work out. It's just an idea, without giving much thought
about possible side effects:

Can we somehow store the PID of the printk() thread that has left the
un-terminated line behind in the buffer, and flush it out when the
next printk() is from a differnt PID? That could prevent the mangling
of "atomic" printk()s by continuation users, and merging unrelated
continuation users together.

Would it make sense to make the printk line buffer per CPU, so they
are not shared between threads, and continuation could work more
reliable?

Kay
