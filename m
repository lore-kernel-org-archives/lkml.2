Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab0DHTim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:38:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57084 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316Ab0DHTik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:38:40 -0400
Date: Thu, 8 Apr 2010 21:38:38 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] loop: Update mtime when writing using aops
Message-ID: <20100408193838.GY10103@kernel.dk>
References: <201004081551.37824.knikanth@suse.de> <20100408124539.GM10103@kernel.dk> <201004081515.56161.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004081515.56161.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08 2010, Tvrtko Ursulin wrote:
> On Thursday 08 April 2010 13:45:39 Jens Axboe wrote:
> > On Thu, Apr 08 2010, Nikanth Karthikesan wrote:
> > > Update mtime when writing to backing filesystem using the address space
> > > operations write_begin and write_end.
> >
> > You forgot to include a 'why' :-)
> >
> > Not that I disagree with the patch, just curious what made you make the
> > change.
> 
> You mean how the bug was found? I originally reported this problem against
> openSUSE 11.2 kernel, where when you have a dm-crypt loop filesystem the
> container file modification time does not get updated with use. Consequence
> of that is that backup runs would miss the fact container has changed.
> 
> Maybe one could argue it is a security feature in this scenario :), but as the
> problem turns out to be unrelated to the crypto case, rather contained in the
> loop driver itself, it looks like that would not hold.

:-)

I suppose you could update the mtime on tear down, since then it would
also be safe to actually backup. But same difference in the end I
suppose, I'll add the patch.

-- 
Jens Axboe

