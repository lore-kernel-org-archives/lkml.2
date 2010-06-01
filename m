Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab0FAEcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 00:32:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab0FAEcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 00:32:35 -0400
Date: Mon, 31 May 2010 21:27:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <alpine.LFD.2.00.1005312024320.3637@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005312122240.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org> <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org> <201006011127.14794.rusty@rustcorp.com.au>
 <alpine.LFD.2.00.1005312024320.3637@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 May 2010, Linus Torvalds wrote:
> 
> Which means that it then cannot clean up properly afterwards if an error 
> happens in the middle.

Oh, I guess it doesn't matter. For the non-unload case, we don't even do 
any module counts, so the fixup ends up being a no-op. So with the error 
handling fixed (which your 2/2 did), I guess it's actually ok. I still 
think it would be nice to have /proc/modules show the module dependencies 
regardless of whether they can be unloaded or not, but that's really just 
an oddity, maybe not a "bug" per se.

		Linus
