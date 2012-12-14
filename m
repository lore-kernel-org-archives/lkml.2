Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab2LNFep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:34:45 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46471 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab2LNFeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:34:44 -0500
MIME-Version: 1.0
In-Reply-To: <87mwxhff2e.fsf@xmission.com>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com> <CALCETrWxXZ1OzZeH_SGeg1E16rssxBwg+hjG09N5dkqweVKeRA@mail.gmail.com>
 <87mwxhff2e.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 21:34:22 -0800
Message-ID: <CALCETrXagfjy4o0_JCZpMfdocYK-MpOp3eH-tPZhgazvJAy-EQ@mail.gmail.com>
Subject: Re: [GIT PULL] user namespace and namespace infrastructure changes
 for 3.8
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 8:11 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> One more issue: the requirement that both upper and lower uids (etc.)
>> in the maps are in order is rather limiting.  I have no objection if
>> you only require upper ids to be monotonic, but currently there's no
>> way to may root outside to uid n (for n > 0) and some nonroot user
>> outside to uid 0.
>
> There is.  You may set up to 5 (extents).  You just have to use a second
> extent for the non-contiguous bits.  My reader is lazy and you have to
> set all of the extents with a single write, so you may have missed the
> ability to set more than one extent.
>

If I'm wrong, I'll happily eat my words.  Both:

0 1 1
1 0 1

and

1 0 1
0 1 1

are rejected, unless I totally messed up.

--Andy
