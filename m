Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882Ab2EJStq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:49:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43732 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760449Ab2EJStp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	<CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	<1336475689.1179.12.camel@mop>
	<CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	<CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	<CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	<CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	<20120509070710.GA29981@gmail.com>
	<CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	<1336611278.728.9.camel@mop>
	<CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
	<1336667984.947.24.camel@mop>
	<CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
Date: Thu, 10 May 2012 11:49:44 -0700
Message-ID: <CA+8MBb+i=J60nqgzBiM+por26s_gRibRt6_YaKMwGqMEYTdDMA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Ingo Molnar <mingo@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 9:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>   This is often useful for having loops that print out individual
> entries all on the same line - print all of them without the '\n'.

Though it is a pain when people do this and the output from each iteration
of the loop gets interleaved with other printk() output.  Perhaps it is OK to
do multiple printk() calls in initialization code where it kernel is
mostly single
threaded. But it should be avoided in "oh dear, something bad happened" bits
of code (in case the badness isn't localized and all the other cpus are spitting
out partial messages too).

-Tony
