Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab2FZABd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:01:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53011 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab2FZABb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:01:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120625235531.GB3652@kroah.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Jun 2012 17:01:11 -0700
X-Google-Sender-Auth: nATAdA1-mKL1Y5OstvkWvPAU4eo
Message-ID: <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 4:55 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Stephen and Ingo, I understand that your tests now would require
> multiple printk() lines, but this affects what, 10 boxes in the world
> that run these tests (I'm not trying to be mean, just understand the
> issues).  The fixes that now are in place fix problems for many more
> systems, and provide the infrastructure for proper logging that people
> have been screaming at us for over 10 years to accomplish.

I disagree violently.

I think we absolutely should apply Steven's patch.

Why? Because the buffering does not help *anything*, and it's
surprising, and it breaks one of our main debugging tools. There's no
upside to it.

The fact that we found *one* case where it broke within days of it
being introduced is not the issue. Fixing that one case is irrelevant.
It's the unknown number of other cases that did similar thngs that
matter.

If there are other places that print out partial lines, they may have
this problem too. Don't buffer.

And if there are *not* other places that print out partial lines, then
buffering doesn't help. Don't buffer.

Notice? Buffering partial lines is never *ever* the right thing to do
for something like printk.

If you want to merge the partial lines, do it at the *logging* stage,
not at the printout stage. Nobody cares if you buffer the stuff that
actually makes it to "dmesg". But buffering the stuff before it makes
it to the screen is just wrong.

                Linus
