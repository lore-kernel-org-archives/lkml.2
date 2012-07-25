Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab2GYXav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:30:51 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41822 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2GYXas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:30:48 -0400
MIME-Version: 1.0
In-Reply-To: <50107A0D.3060003@pobox.com>
References: <20120725203551.GA19762@havoc.gtf.org> <20120725204350.GA20530@havoc.gtf.org>
 <CA+55aFwCCctcmryQJMCT_3TDr60CYBQKu9HMyxOgS8482+w5Xw@mail.gmail.com>
 <50107297.305@pobox.com> <CA+55aFzun7GebfGZDa73MGLF_808+ROaei5Ag-9HvgUDp1bqLQ@mail.gmail.com>
 <50107A0D.3060003@pobox.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Jul 2012 16:30:27 -0700
X-Google-Sender-Auth: Khyje7av7PtFYw7cZAE5YLUDR-o
Message-ID: <CA+55aFwi7wS3SFZA-45d+KwKi+hqn1GXqRExYmOw6gnSipv5Rg@mail.gmail.com>
Subject: Re: [git patches] libata updates
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 3:58 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>
> What is the right course in when a post-merge change is needed?

Just describe the issue and the required change. Than I can just do it
as part of the merge, and now the whole series is bisectable,
including the merge itself.

Here's a (fairly bad) example:

  http://www.spinics.net/lists/netdev/msg192349.html

and the reason I call that a bad example is not because that's a bad
pull request, but simply that those are all real data conflicts, not
the more subtle kind of "it merges fine, but because new code
introduced uses an interface that changed, you need to do xyz".

I couldn't find an example of that in a quick look, it's fairly
uncommon to have non-conflicting merges that had semantic - but not
contextual - conflicts. (Although it does happen, and sometimes it's
actually not the developer, but Stephen Rothwell who notices it in
-next and lets me know before the merge).

                  Linus
