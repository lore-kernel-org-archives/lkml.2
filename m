Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1FJG5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 02:57:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45678 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1FJG5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 02:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mh7p1VT++0qR2qeB4a/gUnfMU1I6/VK9ntO6kc4NRm9YHuBBytICwp3yH9jKGv6n4N
         kUrZeMzUnWZ2SkkhJlSLqwCBAl4TerJm06sVh0I1qzZwmeyAkHTlxGeXtclpfbd0bUw1
         iah+eX0IgiL7EA5T9/q63GO0hUq6WUqMaPrgo=
MIME-Version: 1.0
In-Reply-To: <20110609125114.8dff08da.akpm@linux-foundation.org>
References: <20110609125114.8dff08da.akpm@linux-foundation.org>
Date: Thu, 9 Jun 2011 23:57:09 -0700
X-Google-Sender-Auth: vqYBeRjvX9Lg7blRToR1qUI2R7I
Message-ID: <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com>
Subject: Re: Fw: Re: [PATCH 0/7] overlay filesystem: request for inclusion
From: Valerie Aurora <val@vaaconsulting.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc: NeilBrown <neilb@suse.de>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
>
>
> On Thu, 09 Jun 2011 14:47:49 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> > Another issue: there have been numerous attempts at Linux overlay
>> > filesystems from numerous parties.  Does (or will) this implementation
>> > satisfy all their requirements?
>>
>> Overlayfs aims to be the simplest possible but not simpler.
>>
>> I think the reason why "aufs" never had a real chance at getting merged
>> is because of feature creep.
>>
>> Of course I expect new features to be added to overlayfs after the
>> merge, but I beleive some of the features in those other solutions are
>> simply unnecessary.
>
> This is my main worry.  If overlayfs doesn't appreciably decrease the
> motivation to merge other unioned filesystems then we might end up with
> two similar-looking things.  And, I assume, the later and more
> fully-blown implementation might make overlayfs obsolete but by that
> time it will be hard to remove.
>
> So it would be interesting to hear the thoughts of the people who have
> been working on the other implementations.

1. Al Viro and Christoph Hellwig bring up the same locking problems
*every single time* someone proposes a copy-up in-kernel file system,
and *every single time* they are dismissed or hand-waved.  I'd like to
see the thread in which one of them says, "Why yes, you have
understood and solved that problem to my satisfaction," before even
considering merging something.

2. Overlayfs is not the simplest possible solution at present.  For
example, it currently does not prevent modification of the underlying
file system directories, which is absolutely required to prevent bugs
according to Al.  Al proposed a solution he was happy with (read-only
superblocks), I implemented it for union mounts, and I believe it can
be ported to overlayfs.  But that should happen *before* merging.

3. To my knowledge, Al is not currently able to reply to email on a
regular basis and Christoph doesn't frequently comment on the subject
these days.  Don't take their silence as approval.

I have many more possible comments but I don't think they should be
relevant to the discussion about merging.  Al and Christoph's
judgements should be sufficient.

-VAL
