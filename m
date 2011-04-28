Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1D1LFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:05:37 -0400
Received: from ozlabs.org ([203.10.76.45]:49762 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1D1LFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:05:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
In-Reply-To: <4DB86163.2070201@zytor.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com> <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com> <1303926576.18763.75.camel@gandalf.stny.rr.com> <4DB86163.2070201@zytor.com>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 28 Apr 2011 13:00:26 +0930
Message-ID: <878vuvuk6l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 11:33:07 -0700, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 04/27/2011 10:49 AM, Steven Rostedt wrote:
> > On Tue, 2011-04-26 at 16:45 -0300, Thiago Farina wrote:
> >> This macro is arguably more readable than its variants:
> >> - !strcmp(a, b)
> >> - strcmp(a, b) == 0
> > 
> > Actually, this was proposed way back in 2002 my Rusty and I did not see
> > anyone arguing against it. I wonder why it never was incorporated back
> > then?
> > 
> > http://marc.info/?l=linux-kernel&m=103284339813100&w=2
> > 
> > [ added Cc's of some of those that replied to this thread ]
> > 
> 
> Because !strcmp() is idiomatic C.

I proposed it because I *did* find a bug caused by my own misuse of it.
Only once in 15 years as an experienced C coder, but a bug is a bug.

But why argue; #define it in your code if you want.  If enough people
do, we'll want to unify it.

Personally, I think it's marginal: only those with enough knowledge to
avoid the trap anyway will know to use it, and YA kernel-specific piece
of knowledge cancels the readability benefit.

But who knows, maybe it'll catch on elsewhere too?  That would be a win.

> It doesn't matter if it is more readable *to you*... learn the language,
> please.

That API is crap: insulting the user makes us look foolish.

And even experienced coders can get hit by bad APIs.  The invalidity of
this program shocked me recently:

  #include <ctype.h>
  int main(int argc, char *argv[]) { return isupper(argv[0][0]) ? 1 : 0; }

Thanks,
Rusty.
