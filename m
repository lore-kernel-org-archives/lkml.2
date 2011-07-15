Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1GOQIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:08:37 -0400
Received: from mail.perches.com ([173.55.12.10]:4023 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1GOQIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:08:36 -0400
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
From: Joe Perches <joe@perches.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
	 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
	 <1310744914.7582.36.camel@Joe-Laptop>
	 <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 09:08:34 -0700
Message-ID: <1310746114.7582.45.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 17:57 +0200, Bart Van Assche wrote:
> On Fri, Jul 15, 2011 at 5:48 PM, Joe Perches <joe@perches.com> wrote:
> > On Fri, 2011-07-15 at 12:05 +0200, Bart Van Assche wrote:
> >> Not that's it important, but this change makes is possible to
> >> eliminate the tid[] and lineno[] arrays again. Has that been
> >> considered ?
> > tid and lineno are decimal.  Not using intermediate
> > arrays would require awkward contortions to snprintf
> > them without emitting 0 in the output.
> Sorry, but I do not agree with the above.

Hey Bart.

Then I think you don't understand the goal
of the change.

The goal is to avoid possible interleaving
of multiple printks from different threads.

> The current implementation
> of __dynamic_pr_debug() shows that an implementation without temporary
> arrays does not require any awkward constructs. See e.g.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=lib/dynamic_debug.c
> for the source code of the current implementation of
> __dynamic_pr_debug().
> This may be subjective, but my opinion is that following that style
> results in shorter and more elegant code than the approach with the
> temporary arrays proposed in patch 11/11.

It requires awkward contortions to emit
a decimal value or "" without multiple
printks or temporaries.

cheers, Joe

