Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1JaIM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:12:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33866 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab1JaIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:12:56 -0400
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: John Stoffel <john@stoffel.org>, Johannes Weiner <jweiner@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
In-Reply-To: <3982e04f-8607-4f0a-b855-2e7f31aaa6f7@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	 <75efb251-7a5e-4aca-91e2-f85627090363@default>
	 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
	 <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
	 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
	 <CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com>
	 <20111028163053.GC1319@redhat.com>
	 <b86860d2-3aac-4edd-b460-bd95cb1103e6@default 20138.62532.493295.522948@quad.stoffel.home>
	 <3982e04f-8607-4f0a-b855-2e7f31aaa6f7@default>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 12:12:47 +0400
Message-ID: <1320048767.8283.13.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 13:19 -0700, Dan Magenheimer wrote:
> For those who "hack on the VM", I can't imagine why the handful
> of lines in the swap subsystem, which is probably the most stable
> and barely touched subsystem in Linux or any OS on the planet,
> is going to be a burden or much of a cost.

Saying things like this doesn't encourage anyone to trust you.  The
whole of the MM is a complex, highly interacting system.  The recent
issues we've had with kswapd and the shrinker code gives a nice
demonstration of this ... and that was caused by well tested code
updates.  You can't hand wave away the need for benchmarks and
performance tests.

You have also answered all questions about inactive cost by saying "the
code has zero cost when it's compiled out"  This also is a non starter.
For the few use cases it has, this code has to be compiled in.  I
suspect even Oracle isn't going to ship separate frontswap and
non-frontswap kernels in its distro.  So you have to quantify what the
performance impact is when this code is compiled in but not used.
Please do so.

James


