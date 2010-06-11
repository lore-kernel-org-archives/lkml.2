Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab0FKRom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:44:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755744Ab0FKRol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100611171603.23510.58768.stgit@bumblebee1.mtv.corp.google.com>
References: <20100611171603.23510.58768.stgit@bumblebee1.mtv.corp.google.com>
Date: Fri, 11 Jun 2010 10:44:06 -0700
Message-ID: <AANLkTinlnb-HsDia4X2qgRjkTL_Z5CfVKYHRFwREoyIn@mail.gmail.com>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be 
	reused immediately.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Salman <sqazi@google.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, tytso@google.com,
       akpm@linux-foundation.org, walken@google.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 10:17 AM, Salman <sqazi@google.com> wrote:
> Fixed the whitespace issue that Michel pointed out.
>
> Btw., who is responsible for ACKing this?

I don't know about "responsible", but I'll Ack it. Much of that code
is really old. And exactly since this is a really old issue, I think
I'll leave it unapplied for now, and let it simmer in some test-queue
(get it into next somehow?) until I get back.

Also, now that I look at that complex end-condition for the while-loop
and the big comment, I do start to think that Ingo was right, and it
would be better to make that thing a helper function of its own,
called something like "set_last_pid(pid_ns, last, pid);"

That would lessen the indentation a lot too, and with the commentary,
it would all look fairly pretty.

So Ack-with-cleanup-suggestion. And maybe Andrew can take it into -mm
while I'm gone? Or Ingo into some core-branch? You fight it out, but I
think  this is already acceptable, just perhaps still open to
improvement.

                       Linus
