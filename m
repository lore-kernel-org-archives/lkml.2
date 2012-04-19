Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2DSRh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab2DSRh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:37:27 -0400
Date: Thu, 19 Apr 2012 19:36:43 +0200
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
Message-ID: <20120419173643.GA27143@redhat.com>
References: <20120417193409.GA20312@redhat.com> <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com> <20120417163606.GC14527@redhat.com> <23383.1334854333@redhat.com> <20120419173431.GA27066@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419173431.GA27066@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to mention...

On 04/19, Oleg Nesterov wrote:
> On 04/19, David Howells wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > +#define key_replace_session_keyring()	do { } while (0)
> > > +
> >
> > Ummm... Why?  You've made the function no longer exist and so this shouldn't be
> > there anymore.  You shouldn't just leave the call sites in place.
>
> Sure!
>
> I'll send the (trivial) patches to cleanup the code in arch/ (24 callers),
> plus we should kill the no longer used task ->replacement_session_keyring
> and update copy_creds/exit_creds.

... and we should kill tracehook_notify_resume()

> But I certainly do not want to put these changes in 3/3 or in this series.
> I'll send the patches to Andrew once (I hope ;) he takes 1-3.

Yes.

Oleg.

