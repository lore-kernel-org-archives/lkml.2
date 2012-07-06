Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2GFNqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:46:02 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:34849 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2GFNqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:46:00 -0400
Date: Fri, 6 Jul 2012 15:45:55 +0200
Message-Id: <201207061345.q66DjtJl016985@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: geert@linux-m68k.org
CC: jack@suse.cz, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cris-kernel@axis.com
In-reply-to: <CAMuHMdU+GdPnEgdJJFezPET5y4Q0-fqBJZZZ1cNZyPOG6_d4Ug@mail.gmail.com>
	(message from Geert Uytterhoeven on Fri, 6 Jul 2012 09:18:52 +0200)
Subject: Re: size_t/ssize_t warnings (was: Re: Build
 regressions/improvements in v3.5-rc5)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Fri, 6 Jul 2012 09:18:52 +0200

> On Fri, Jul 6, 2012 at 3:12 AM, Hans-Peter Nilsson
> <hans-peter.nilsson@axis.com> wrote:
> > Um, no, ssize_t isn't long.  Do you mean __kernel_ssize_t?
> 
> In the kernel, (s)size_t == __kernel_(s)size_t

Right, sorry for being slow.

> OK, so (s)size_t should be (unsigned) int for Linux.

Both the the kernel and userspace, yes.

> Probably the "long" dates from the time people used cris-axis-elf
> instead of cris-axis-linux-gnu, and "__SIZE_TYPE" from the time
> people started using cris-axis-linux-gnu?

I don't remember.  I have a vague recollection of a change in
the distant past.

> Ah, yes, commit ac505a9fd19c99fdb622fe4896446f995151babc
> ("[PATCH] CRIS architecture update for 2.5.74") in full-history-linux
> changed size_t from "unsigned long" to __SIZE_TYPE, but didn't
> update ssize_t. Probably "signed __SIZE_TYPE" doesn't work?

Well no.  Remember here it's "unsigned int": "signed unsigned
int" doesn't compile very well.

> So I guess they should be changed to (explicit) "unsigned int", resp.
> "int". Or does it make sense to retain __SIZE_TYPE?

I think it'd make sense to use __SIZE_TYPE__ (don't forget the
trailing "__") for *all* targets that don't have a particular
difference between kernel and userspace ABI's (notable
exceptions being those with use 32-bit user and 64-bit kernel
ABIs).  Unfortunately, there's no __SSIZE_TYPE__.

brgds, H-P
