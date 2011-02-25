Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab1BYS6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:58:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756279Ab1BYS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <20110225175249.GC19059@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com>
 <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com> <20110225175249.GC19059@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 Feb 2011 10:57:09 -0800
Message-ID: <AANLkTinY3QbtZx=2Vo=pCy-b0z_BXK1f1AqXYwNg_Sje@mail.gmail.com>
Subject: Re: [PATCH 2/5] exec: introduce "bool compat" argument
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 9:52 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> No functional changes, preparation to simplify the review.

I think this is wrong.

If you introduce the "bool compat" thing, you should also change the
type of the argument pointers to some opaque type at the same time.
It's no longer really a

  const char __user *const __user *

pointer at that point. Trying to claim it is, is just wrong. The type
suddently becomes conditional on that 'compat' variable.

                        Linus
