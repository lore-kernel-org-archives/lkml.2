Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab1FIMrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:47:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45491 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab1FIMrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ODPFJ6kkyJieQ1KbHCtZiof4ppRSTM1F/C8ejXjKMIadXaC9fzq7zpSVkIrr8l1ncm
         6FEtPY+EzUaIRv+XYX8hMBjj9clixL9CMyyw7KZQZyO4C22eoOtt81s08uFYiSRSajI2
         g9XGEW39OOYlWKEgblaqWOywLW7sIjI4yuHEc=
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
Date: Thu, 09 Jun 2011 14:47:49 +0200
In-Reply-To: <20110608205233.ebfedc4d.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 8 Jun 2011 20:52:33 -0700")
Message-ID: <87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 9 Jun 2011 11:59:34 +1000 NeilBrown <neilb@suse.de> wrote:
>
>> On Wed, 8 Jun 2011 15:32:08 -0700 Andrew Morton <akpm@linux-foundation.org>
>> wrote:
>> > I've never really understood the need for fs overlaying.  Who wants it?
>> > What are the use-cases?
>> 
>> https://lwn.net/Articles/324291/
>> 
>> I think the strongest use case is that LIVE-DVD's want it to have a
>> write-able root filesystem which is stored on the DVD.
>
> Well, these things have been around for over 20 years.  What motivated
> the developers of other OS's to develop these things and how are their
> users using them?

That's a good question, Erez might be able to answer that better.

We have customers who need this for the "common base + writable
configuration" case in a virtualized environment.

Since overlayfs's announcement several projects have tried it and have
been very good testers and bug reporters.  These include OpenWRT, Ubuntu
and other Debian based live systems.

>> > This sort of thing could be implemented in userspace and wired up via
>> > fuse, I assume.  Has that been attempted and why is it inadequate?

Yes, unionfs-fuse and deltafs (written by me) are two examples.

One issue that a customer had with deltafs was lack of XIP support.  The
other one (from the same customer) was the general yuck factor of
userspace filesystems.

There are also performance and resource use issues associated with
userspace filesystems.  These may or may not be problem depending on the
actual use.  But it's a fact that out-of-kernel filesystems will never
be as efficient as in-kernel ones.

>> I think that would be a valid question if the proposal was large and
>> complex.  But overlayfs is really quite small and self-contained.
>
> Not merging it would be even smaller and simpler.  If there is a
> userspace alternative then that option should be evaluated and compared
> in a rational manner.
>
>
>
> Another issue: there have been numerous attempts at Linux overlay
> filesystems from numerous parties.  Does (or will) this implementation
> satisfy all their requirements?

Overlayfs aims to be the simplest possible but not simpler.

I think the reason why "aufs" never had a real chance at getting merged
is because of feature creep.

Of course I expect new features to be added to overlayfs after the
merge, but I beleive some of the features in those other solutions are
simply unnecessary.

Thanks,
Miklos
