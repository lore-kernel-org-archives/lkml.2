Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab1BZMqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 07:46:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1BZMqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 07:46:07 -0500
Date: Sat, 26 Feb 2011 13:37:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 2/5] exec: introduce "bool compat" argument
Message-ID: <20110226123713.GB4416@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com> <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com> <20110225175249.GC19059@redhat.com> <AANLkTinY3QbtZx=2Vo=pCy-b0z_BXK1f1AqXYwNg_Sje@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinY3QbtZx=2Vo=pCy-b0z_BXK1f1AqXYwNg_Sje@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Linus Torvalds wrote:
>
> On Fri, Feb 25, 2011 at 9:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > No functional changes, preparation to simplify the review.
>
> I think this is wrong.
>
> If you introduce the "bool compat" thing, you should also change the
> type of the argument pointers to some opaque type at the same time.
> It's no longer really a
>
>   const char __user *const __user *
>
> pointer at that point. Trying to claim it is, is just wrong. The type
> suddently becomes conditional on that 'compat' variable.

Yes, this is true.

And I agree this could be done in more clean way, just we need more
changed. Please see the next email.

Oleg.

