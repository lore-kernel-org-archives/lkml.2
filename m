Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0EZPoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:44:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316Ab0EZPoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:44:22 -0400
Date: Wed, 26 May 2010 08:41:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [Regression] Crash in load_module() while freeing args
In-Reply-To: <201005261730.59058.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1005260834460.3689@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005260054.52122.rjw@sisk.pl> <alpine.LFD.2.00.1005251639420.3689@i5.linux-foundation.org> <201005261730.59058.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 May 2010, Rusty Russell wrote:
> 
> So then we have the problem that crc32 is finished its init and needs the
> lock back, and bnx2x which needs crc32 is waiting for it.  We could just
> fail bnx2x; and in fact, we did prior to this patch (we timeout) and it breaks
> network on booting on some box according to Brandon:

So the sane thing to do seems to simply not get that mutex_lock after a 
successful init. Which probably implies having a new lock for the actual 
low-level symbol table stuff.

		Linus
