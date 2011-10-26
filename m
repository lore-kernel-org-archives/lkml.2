Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab1JZOAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:00:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35089 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab1JZOAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <20111026120725.GA23142@kroah.com>
References: <20111026120725.GA23142@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Oct 2011 15:59:40 +0200
X-Google-Sender-Auth: xkRMOPXECvZZSxUsPryxh3vgg4I
Message-ID: <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
Subject: Re: [GIT PATCH] big staging merge for 3.2
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, Mark Einon <mark.einon@gmail.com>,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 2:07 PM, Greg KH <greg@kroah.com> wrote:
>
> Here is the big staging merge for 3.2
>
> Note, I ended up merging this with your 3.1 release to resolve a merge
> issue with one of the comedi drivers to fix a build issue.  If you want
> me to redo the tree without this merge, I'll be glad to do so and let
> you do it :)

I don't hate merges that make sense, and that one looks fine. You
picked a logical merge point, and you wrote a merge message that
explains it. No problem.

> There's a lot of patches in here, and the overall diff is quite
> impressive:
>  834 files changed, 103718 insertions(+), 230262 deletions(-)

Hmm... I only get

 725 files changed, 103936 insertions(+), 180480 deletions(-)

Which is still good, but nothing like your numbers. Where did you find
the extra 50k lines?

> All patches have been in the -next releases for a while now.

So I got several conflicts with the networking tree. Most of them were
trivial (eg driver removal conflicting with somebody trying to fix up
the now dead driver), but I really hope somebody looks at the
resulting drivers/staging/et131x/et131x.c file.

That driver wasn't removed, it was consolidated as one big file, and
so the fixes to the original files needed to be resolved. I tried to
do that correctly, but there's the skb_frag_dma_map() change and the
removal of .ndo_set_multicast_list, and while I think I did it right,
I really want somebody who knows that code to double check me.

Appropriate people to do that added to the cc,

                 Linus
