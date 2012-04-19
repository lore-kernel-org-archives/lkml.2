Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab2DSTsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab2DSTsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:48:21 -0400
Date: Thu, 19 Apr 2012 21:47:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] cred: change keyctl_session_to_parent() to use
	task_work_add()
Message-ID: <20120419194734.GA16740@redhat.com>
References: <20120419173431.GA27066@redhat.com> <20120417193409.GA20312@redhat.com> <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com> <20120417163606.GC14527@redhat.com> <23383.1334854333@redhat.com> <25695.1334858133@redhat.com> <20120419181010.GA29793@redhat.com> <27773.1334864058@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27773.1334864058@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > I am not going to argue, but honestly I don't think it is a good
> > idea to mix the functional changes in keyctl.c and the simple
> > (but obviously untested) cleanups.
>
> I meant add the cleanup as patch 4.  That way they are still separate.  I'll
> let you change the name of the function to make it easier;-)

OK.

I'd like to avoid the unnecessary resends, lets discuss this before
I send the patch(es).

At least I'd like to split this into 2 patches:

	4/3: only removes the dead code from arch/*

	5/3: updates copy_creds/exit_creds and kills
	     ->replacement_session_keyring, plus renames
	     key_change_ back to key_replace_

Do you agree?

Oleg.

