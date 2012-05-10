Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718Ab2EJV6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:58:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45286 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761648Ab2EJV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:58:30 -0400
MIME-Version: 1.0
In-Reply-To: <1336684277.29763.12.camel@joe2Laptop>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
 <20120509070710.GA29981@gmail.com> <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
 <1336611278.728.9.camel@mop> <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
 <1336667984.947.24.camel@mop> <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
 <1336682226.29763.2.camel@joe2Laptop> <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
 <1336682772.29763.6.camel@joe2Laptop> <CA+55aFwJgtVr9ZndEU-yhJW3wi-5Omga51pjun+J213awQwJZA@mail.gmail.com>
 <1336684277.29763.12.camel@joe2Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 May 2012 14:58:08 -0700
X-Google-Sender-Auth: pLZdXENju7qkuRXQD2ViFZRvqag
Message-ID: <CA+55aFygHfYd3O5-sBg32_Vcn6GOm7irr2R8jW6QVPuepXTeWw@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 2:11 PM, Joe Perches <joe@perches.com> wrote:
>
> I think it's a distinction without a difference for,
> as fas as I know, that's a case that doesn't exist
> in the current kernel.

So? Even if we hadn't had this bug before (we have), your argument is
utter crap. Even if we weren't to have that patter right *now*, that
doesn't mean that it cannot happen.

Your grep is also not at all exhaustive. What if somebody does

   printk("%s.."

how are you going to prove that '%s' doesn't contain a level marker
thing? It's much easier to just say "use a KERN_CONT" (or more
commonly KERN_DEFAULT) to avoid the problem.

We do need an escape model. The current KERN_CONT does that. Stop
arguing for crap.

                 Linus
