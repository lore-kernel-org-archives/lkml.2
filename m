Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2FCX6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 19:58:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab2FCX6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 19:58:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ACPI & Power Management Patches for Linux-3.5-merge
Date: Mon, 4 Jun 2012 02:03:29 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, "linux-acpi" <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4FC9B39B.403@kernel.org> <CA+55aFyGqZnVvd5-ZLUkS=EE72QG1FqempZrs+vBLyCkWP6T_Q@mail.gmail.com>
In-Reply-To: <CA+55aFyGqZnVvd5-ZLUkS=EE72QG1FqempZrs+vBLyCkWP6T_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206040203.29928.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 03, 2012, Linus Torvalds wrote:
> On Fri, Jun 1, 2012 at 11:32 PM, Len Brown <lenb@kernel.org> wrote:
> >
> > ps. Sorry for sending this request at the tails of the merge window --
> > I'll try to be earlier next time.
> 
> Christ, not only is it after I really wanted to do -rc1 (held up by
> the tty locking problems), but it doesn't even compile.
> 
> Find the bug (the compiler certainly did):
> 
> static inline int acpi_pm_device_sleep_state(struct device *d, int *p, int m)
> {
>         if (p)
>                 *p = ACPI_STATE_D0;
>         return (m >= ACPI_STATE_D0 && <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
> }
> 
> and no, it wasn't a merge error. That's what it looks like in your tree.
> 
> The commit was done yesterday. It clearly had *zero* testing.
> 
> Looking more at the pull as a result of this, I notice that almost
> every commit in that tree is from yesterday, and thus cleary cannot
> have been in -next. I was going to just fix up the obvious one-liner
> fixup, but looking at the bigger picture I'm going to say "3.6
> material" for this whole thing.

Well, perhaps you could take my branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-acpi

which was included into the Len's pull, for 3.5?

It was ready a few days ago, and has been present in linux-next even longer
and contains fixes for real bugs.  I didn't push it myself, because it
generally is ACPI material, but since you're not going to take the Len's
tree now, can you please consider taking that branch at least?

Rafael
