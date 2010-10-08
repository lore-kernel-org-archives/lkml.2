Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab0JHMGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:06:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:48960 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504Ab0JHMGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:06:45 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: Linux 2.6.36-rc7
Date: Fri, 8 Oct 2010 14:06:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <20101007190741.2dc62626@lxorguk.ukuu.org.uk> <1286473768.2656.21.camel@dhcp231-98.rdu.redhat.com>
In-Reply-To: <1286473768.2656.21.camel@dhcp231-98.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010081406.10190.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 October 2010 19:49:28 Eric Paris wrote:
> The safest thing would probably be to punt the syscalls to 2.6.37.
> Which is sad since I know a number of people are already working against
> them, but maybe that proves it's the best approach?

I agree with removing the syscalls from 2.6.36 because of the following 
reasons:

 * Reviewers have complained that the feature was not ready to be merged, yet.

 * At least some of the criticism did not get addressed (neither discussed nor
   fixed).

 * Some weaknesses in the interface design were only identified and fixed late
   in the -rc phase, changing the ABI.  There may be more issues, like the
   priority discussion.  This might leave us with a broken ABI we would need
   to support forever.

   (Making fanotify fit for HSM hasn't been thought through at all AFAIK but
   fanotify has legitimate use cases apart from HSM, so I don't necessarily
   consider this a blocker.)

 * The code has shown to contain the kinds of bugs which show that it was not
   tested very well before merging.

Thanks,
Andreas
