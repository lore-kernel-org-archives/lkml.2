Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1JOXtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 19:49:33 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45994 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab1JOXtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 19:49:31 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1110151543220.25063@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <alpine.DEB.2.00.1110151543220.25063@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 18:49:27 -0500
Message-ID: <1318722567.7271.56.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 16:03 -0700, David Rientjes wrote:
> On Fri, 14 Oct 2011, James Bottomley wrote:
> 
> > It's not incredibly trivial: it causes a compile failure on parisc:
> > 
> > mm/percpu.c:1372: error: __setup_str_percpu_alloc_setup causes a section
> > type conflict
> > make[1]: *** [mm/percpu.o] Error 1
> > 
> > I have no idea why, though.
> > 
> 
> Not sure why this would only happen on parisc, but I haven't looked at it 
> closely.  It means something qualified with const is being defined in a 
> section with other definitions that are not const, or vice versa.

I think it's probably a compiler bug.  gcc isn't as adept with section
annotations as people think it is.  This tends to manifest in the
non-x86 toolchains because we tend to be using earlier versions.

James


