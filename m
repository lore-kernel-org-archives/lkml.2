Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1DUSAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:00:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab1DUSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:00:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1104211051490.18728@trent.utfs.org>
References: <20110415035451@it-loops.com> <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com>
 <20110415042255.GC27928@infradead.org> <4DA7E202.4000307@fusionio.com> <alpine.DEB.2.01.1104211051490.18728@trent.utfs.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Apr 2011 10:59:39 -0700
Message-ID: <BANLkTim7SLt6TMqJQw35=tnACax0mE1URA@mail.gmail.com>
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with 2.6.39-rc[123]]
To: Christian Kujau <lists@nerdbynature.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@infradead.org>,
        Michael Guntsche <mike@it-loops.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:53 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Fri, 15 Apr 2011 at 08:13, Jens Axboe wrote:
>> I think we are done, Neil just needs to rebase around the current
>> for-linus and then we should expedite things in.
>
> Whatever this was: has it been pushed to Linus yet? I'm on 2.6.39-rc4+
> (from yesterday) and I too experience a hang during boot (and other
> strange things with udev[0])

As of right now, all _known_ block bugs should be fixed in the stuff I
just pushed out, with the current top-of-tree being the merge of the
IDE CD endless loop issue and the NULL ptr oops at elevator change
time:

     Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

    * 'for-linus' of git://git.kernel.dk/linux-2.6-block:
      ide: unexport DISK_EVENT_MEDIA_CHANGE for ide-gd and ide-cd
      block: don't propagate unlisted DISK_EVENTs to userland
      elevator: check for ELEVATOR_INSERT_SORT_MERGE in !elvpriv case too

but maybe yours is something else.

That said, that udevd message of yours would imply a full root
filesystem, which can cause any amount of issues at boot time..

                          Linus
