Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0FBDQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:16:03 -0400
Received: from ozlabs.org ([203.10.76.45]:52776 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0FBDQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:16:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Wed, 2 Jun 2010 12:45:57 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005312024320.3637@i5.linux-foundation.org> <201006011449.51587.rusty@rustcorp.com.au>
In-Reply-To: <201006011449.51587.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021245.59076.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 02:49:50 pm Rusty Russell wrote:
> I wonder if we should just get rid of !CONFIG_UNLOAD then?  I have a soft spot
> for it because it keeps us honest and shows how much shit is there simply for
> our poor man's pagable kernel.
> 
> Let me compile up a kernel with and without and see what it's really doing
> to us...

With a distro-style config (copied Ubuntu then held down Enter on oldconfig)
it's:
		Vmlinux	module.o (text/data)	Total module size (text/data)
With unload	8976331	24144/1036		47255565/3298004
Without unload	8962022	20551/732		47176064/3222068
Without modules 8723931

So, we pay 14k for module unload support, or 0.2%, and 0.3% across the
modules themselves.  There's real runtime costs, too, but someone would need
to annotate and see how often we do inc/dec in a real system.

Not sure that last one is exactly comparable, but it looks like module
support is a significant cost...

Cheers,
Rusty.
