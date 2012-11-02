Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2KBBAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 21:00:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63239 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2KBBAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 21:00:09 -0400
MIME-Version: 1.0
In-Reply-To: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com>
References: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Nov 2012 17:59:47 -0700
X-Google-Sender-Auth: sgJT51XLOSnF6JyfbHcApcS8-Ow
Message-ID: <CA+55aFxxdFCiOHEz_xWx1vjMkpQzab_Mdmd2dweknayhVBx6kA@mail.gmail.com>
Subject: Re: [RFC] hlist: drop the node parameter from iterators
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, mingo@kernel.org,
        hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        peter.senna@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 4:06 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> I'm not sure why, but the hlist for each entry iterators were conceived
> differently from the list ones. While the list ones are nice and elegant:
>
>         list_for_each_entry(pos, head, member)
>
> The hlist ones were greedy and wanted an extra parameter:
>
>         hlist_for_each_entry(tpos, pos, head, member)
>
> Why did they need an extra pos parameter? I'm not quite sure. Not only
> they don't really need it, it also prevents the iterator from looking
> exactly like the list iterator, which is unfortunate.
>
> [..]
>  170 files changed, 481 insertions(+), 879 deletions(-)
>
> Yes, beyond making hlist prettier, we also drop 400 lines. win-win?

So this has been discussed before, and one of the problems with this
is just the pain of maintenance. This tends to cause annoyances for
merging, but also for -stable backporting etc, because it just results
in a lot of noise.

Now, the hlist_for_each() case isn't used by quite as many sites as
some of the others helpers like this, so maybe the pain isn't horribly
bad, but in general I do tend to get nervous about "let's clean it up"
when it touches hundreds of files.

Your thing looks nice in that it has the coccinelle script (which
hopefully means that we really get them all), but just out of
interest, how different is the patch after running the script on both

 (a) my current -git head
 (b) linux-next

because differences (other than just line numbers) imply conflicts.
How many differences are we talking about? None? Two? Twenty?

(That said, right now linux-next is tiny. It might be more interesting
to look at the linux-3.5 vs linux-3.6 to get more of a feel for
differences between releases. Doing just the diff+grep thing, there's
quite a few changes around hlist_for_each_entry() uses)

                     Linus
