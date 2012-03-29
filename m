Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab2C2Uiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:38:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65091 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2C2Uip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:38:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120329202619.GA14001@redhat.com>
References: <20120329155542.GA31285@redhat.com> <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com> <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com> <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 13:38:23 -0700
X-Google-Sender-Auth: kbD02aF6iuucquzE4U0sF64Ycw8
Message-ID: <CA+55aFyvuAs6=1fEaFaWUjRNUyKGSnKSSa031vFx7OpCvWJbYQ@mail.gmail.com>
Subject: Re: lockups shortly after booting in current git.
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 1:26 PM, Dave Jones <davej@redhat.com> wrote:
>
> I'll go back to trying the bisect now that I know how to reproduce it quickly.
> Do you think it might be worth restricting the bisect to fs/ ?
> Or shall I just do the whole tree bisect from 3.3 ?

Despite my "it looks like writes only" theory it *might* be a libata
issue (I assume this is a SATA drive), so I wouldn't force it to just
fs/.

There are also patches in mm/, and who knows if it might be some
locking or RCU change that triggers it too.

So I would suggest a whole-tree bisect. At least start out that way
for a few rounds. It's painful when there has been 8000+ commits since
v3.3, but it may be that as you bisect it becomes clear that it's some
particular subsystem, and at *that* point maybe it's worth saying
"don't bother bisecting through all the ARM changes", just start a new
bisect with the known good/bad points and limit it to subsystem X.

After three bisections, you should be down to a thousand commits. And
at that point it becomes worth looking at "ok, which subsystems seem
to be represented in these 1000 commits" to see if you can narrow
things down.

                            Linus
