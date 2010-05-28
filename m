Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0E1TFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:05:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab0E1TFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:05:44 -0400
Date: Fri, 28 May 2010 21:03:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 2/3] sys_personality: make sure (int)personality >= 0
Message-ID: <20100528190344.GA12090@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153613.GC13858@redhat.com> <4BFECFEB.6040308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFECFEB.6040308@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, H. Peter Anvin wrote:
>
> On 05/27/2010 08:36 AM, Oleg Nesterov wrote:
> >
> > Change sys_personality() to ensure personality can not look like a
> > negative int. This disallows the MSB, it is not used for PER_ flags.
> >
> I'm fine with this, even though it is indeed there to support extremely
> poorly written applications (error is specifially -1, not < 0).

Completely agreed. I never liked this patch, just tried to discuss this
"problem" and report either ACK or NACK back to bugzilla.

Now I dislike it even more. I am not going to resend it, but I added
the fat note to the patch-v2 I am sending.

> However, since we almost certainly have enough brokenness in here, and
> since there definitely don't seem to be a whole lot of demand for new
> personality bits, I'm more than happy to waste bit 31 at not having to
> deal with it, ever.
>
> However, it would be better if we returned -EINVAL on attempts to set
> *any* of the reserved bits, not just bit 31.

If only I knew what is the supposed behaviour of sys_personality ;)

Another reason to forget this patch but add the "right" check if needed.

Oleg.

