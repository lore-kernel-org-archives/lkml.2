Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986Ab0E0SSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:18:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46228 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934966Ab0E0SSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:18:35 -0400
Date: Thu, 27 May 2010 20:18:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 1/3] sys_personality: validate personality before
	set_personality()
Message-ID: <20100527181829.GC6800@basil.fritz.box>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com> <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com> <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:51:46AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 27 May 2010, Oleg Nesterov wrote:
> > 
> > But. Suppose an application does personality(0xffffffff << 32) on x86_64.
> > 
> > Before this patch we return -EINVAL (but wrongly change ->personality).
> > After this patch this is equal to personality(0), right?
> 
> Yes. And I'm willing to take that "risk" in the name of not having to 
> carry crazy stuff around in the kernel.

Perhaps we can have a personality with the old personality behaviour @) 

Just joking, I doubt anything really cares. I don't think personality
was used much in 64bit except for uname emulation.

-Andi
