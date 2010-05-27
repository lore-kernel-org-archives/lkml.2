Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502Ab0E0SDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934216Ab0E0SDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:03:15 -0400
Date: Thu, 27 May 2010 10:51:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 1/3] sys_personality: validate personality before
 set_personality()
In-Reply-To: <20100527171530.GA18284@redhat.com>
Message-ID: <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com>
 <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 May 2010, Oleg Nesterov wrote:
> 
> But. Suppose an application does personality(0xffffffff << 32) on x86_64.
> 
> Before this patch we return -EINVAL (but wrongly change ->personality).
> After this patch this is equal to personality(0), right?

Yes. And I'm willing to take that "risk" in the name of not having to 
carry crazy stuff around in the kernel.

I don't think anybody does anything like that. At worst, they may have 
done sign-extension (due to lack of prototypes, whatever), and _wanted_ to 
do "personality(0xffffffff)" but instead ended up with the high bits set, 
and a non-working system call.

In which case the cleanup just helps such clueless cases. Not that I think 
those exist _either_, but whatever.

> If you think this is fine - I agree. In case we have a bug report we
> know who should be blamed ;)

Yup. I'll take the blame.

> You can also remove this "return -EINVAL", this is no longer possible.

I've already removed the patch from my tree, I wasn't going to commit it 
without somebody testing it. So maybe you could re-do the series with that 
cleanup too?

		Linus
