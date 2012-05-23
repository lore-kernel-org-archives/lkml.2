Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2EWJEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab2EWJEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:04:04 -0400
Message-ID: <1337763839.2225.11.camel@perseus.themaw.net>
Subject: Re: [PATCH] autofs4 - fix get_next_positive_subdir()
From: Ian Kent <ikent@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Wed, 23 May 2012 17:03:59 +0800
In-Reply-To: <1337758248.2225.9.camel@perseus.themaw.net>
References: <20120523024950.3905.89811.stgit@perseus.themaw.net>
	 <CA+55aFwCESHx0d+ZEe-zi3PS6mkMaMng75Dnfit93cTwhb5gSg@mail.gmail.com>
	 <1337757721.2225.8.camel@perseus.themaw.net>
	 <1337758248.2225.9.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 15:30 +0800, Ian Kent wrote:
> On Wed, 2012-05-23 at 15:22 +0800, Ian Kent wrote:
> > On Tue, 2012-05-22 at 19:53 -0700, Linus Torvalds wrote:
> > > On Tue, May 22, 2012 at 7:49 PM, Ian Kent <ikent@redhat.com> wrote:
> > > >
> > > > The locking for the list traversal in get_next_positive_subdir() is
> > > > wrong, so fix it.
> > > 
> > > As an explanation, this kind of thing is totally useless. It doesn't
> > > actually give any information at all. It's like saying "change
> > > locking"
> > > 
> > > What happened, and why? Why is the new nested spinlock ok and won't
> > > deadlock against other nested users? Wazzup?
> > 
> > It's good that you questioned this Linus.
> > 
> > Looking again at dput() I think the traversal still isn't quite right.
> > 
> > For a start the test for d_count 0 or positive and hashed can never be
> 
> Correction, that second check is actually !(positive and hashed) in the
> code.
> 
> > true since the point of the change was to take the d_lock of the
> > d_subdirs dentry for the traversal.

That's not right, ignore this.

> > 
> > I'll need to work on this some more, thanks.
> > Ian
> 


