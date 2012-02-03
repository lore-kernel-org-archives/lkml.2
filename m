Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2BCScK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:32:10 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53810 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab2BCScH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:32:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1RGDWLM58+vBPEd-JKLN+MNHuX4JRme9GocsVCQsuxNU7R8w@mail.gmail.com>
References: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
 <CAL1RGDWLM58+vBPEd-JKLN+MNHuX4JRme9GocsVCQsuxNU7R8w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Feb 2012 10:31:47 -0800
X-Google-Sender-Auth: Gfi2qbpnJmum9YDVd6f8NjRVz5g
Message-ID: <CA+55aFwCQH9FEGdx7RwmNPyEEan2=ZmsSYLa0wdu6zce4k6Wmw@mail.gmail.com>
Subject: Re: Linux 3.3-rc2
To: Roland Dreier <roland@purestorage.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 1:05 PM, Roland Dreier <roland@purestorage.com> wrote:
>
> I know you're rarely shy about giving feedback

Actually, most of the time I have a very laissez-faire attitude about
a lot of things. I tend to give "feedback" when something particular
triggers my "that's not ok" filter.

Which is why I curse a lot in public. If things look fine, I just let it go.

>                                                   but I'm curious if we're
> far enough along in this signed tag pulling stuff for you to have thoughts
> about best practices for the tag contents.  For example if you look at
> my recent 18d3e0d75079 is there anything you'd rather have different
> (although of course that was a very boring tag with no controversial
> contents and no conflicts)?  Any naming conventions for tags?  Anything
> else you want an excuse to pontificate about?

I really think it tends to be pretty open. What I *don't* like is
redundant information that simply doesn't help a human reader.

This covers both tag naming and tag contents. The common example is
something like putting dates or random crud into the tag name. It's
redundant because the tag will actually have a real date inside of it
*twice* - the gpg signing itself gives it a date, and git tags are
dated even when not signed.

But even if the tag didn't contain a date anywhere, adding the date to
the tag-name is pointless. It seems to be something that people do as
a way to make naming "unique", but I really don't think those things
should be considered long-lived or have any external meaning anyway,
so that's kind of pointless.

So if you think "for-linus" is a bit boring, and "for-3.3-rc3" is too
nondescriptive, what I absolutely *love* people to do is name their
tags by the feature they implement. It can be as simple as "fixes" if
that's the best you can come up with, but if you send me multiple pull
requests per merge window, I *love* getting them by feature, and
having a slightly descriptive name for the branch too - it's not only
documentation for the tag message itself, it also shows how organized
and thoughtful you were.

But I really don't mind the "for-linus" naming either, especially not
for git trees where the tree itself is implicitly the "feature" (eg an
architecture like "microblaze", where the fact that I merge the
updates for that architecture is in itself enough information for 99%
of all people).

So I just pulled the latest sound fixes, and the branch name was
'sound-fixes'. That's _fine_. It makes perfect sense.

As to the actual contents of the tag message, it's really just the
exact same thing on a slightly bigger scale. It's like the "first line
of a commit message" vs the "body of the commit message" issue: the
branch name would condense things into a single word or two, the tag
message should be a "extended explanation".

And sometimes you just don't need a body at all. After all, the merge
message will contain the first line of up to roughly 20 commits, so
together with a tag name like "sound-fixes", maybe it really doesn't
need anything more.

So I don't think there are any hard rules. Again, just to pick what is
currently my top commit, I think the tag message of

    sound fixes for 3.3-rc3

    Most of commits are either regression fixes for varioud HD-audio
    codecs or small ASoC fixes.  Also a trivial build fix is included.

was entirely appropriate. It's a fine human-readable description of a
set of patches that simply aren't all that interesting.

But at other times, a bit more detail looks great. For example of just
a couple of pretty boring fixes, but more of a description of them,
look at the firewire merge (commit bd3ce7d57c38). It's still just
small fixes, but it explains who it might matter for. Good job -
relevant information for real people.

And I think your message in commit 18d3e0d75079 falls solidly into
that camp of "relevant information for real people". I have absolutely
no complaints - that's exactly the kind of thing I like to see.

And at the same time, sometimes even more information is certainly
nice. Especially for the big series that get merged during the merge
window, i fyou have a writeup for them, feel free to use it. If I'm
merging a thousand commits in a single pull, there is no reason why
the commit message cannot be tens of lines of explanation for what the
commits do.

Right now, only davem does that, and he doesn't even use signed tags,
so I end up cutting-and-pasting the explanation from the email (which
is not a bgi problem - the bigger problem is that current git versions
don't start the editor when I do a "git pull", and sometimes I just
*forget* as a result).

I certainly wouldn't mind others doing the same kind of thing,
although in all honesty, davem does need to do it more than most -
exactly because I get a *lot* of commits from him. Other prolific
submaintainers (like Ingo) tend to split things up a bit more, so
their branches are more self-descriptive than the big network merge
needs to be.

                                    Linus
