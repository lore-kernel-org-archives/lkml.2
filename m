Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2JEPsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:48:52 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52577 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2JEPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:48:51 -0400
Date: Fri, 5 Oct 2012 17:48:47 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005154847.GB246@x4>
References: <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
 <20121005125717.GB245@x4>
 <20121005142639.GA20065@kroah.com>
 <20121005152948.GC24764@aftab.osrc.amd.com>
 <20121005153706.GA13571@kroah.com>
 <20121005154312.GF24764@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005154312.GF24764@aftab.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.10.05 at 17:43 +0200, Borislav Petkov wrote:
> On Fri, Oct 05, 2012 at 08:37:06AM -0700, Greg Kroah-Hartman wrote:
> > So WARN_RATELIMIT was never working properly? If so, how far back does
> > it go in kernel releases that this should be fixed?
> 
> Since b3eec79b0776e which added it in May 2011. But the only one othe r
> user is net/core/filter.c.

But it doesn't matter, because the WARN_RATELIMIT in net/core/filter.c
is guarded by a switch statement and uses WARN_RATELIMIT(1,...). So it
could never trigger the bug.

-- 
Markus
