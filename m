Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab0DIFVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 01:21:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:55482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab0DIFVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:21:04 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] loop: Update mtime when writing using aops
Date: Fri, 9 Apr 2010 10:52:32 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201004081551.37824.knikanth@suse.de> <201004081515.56161.tvrtko.ursulin@sophos.com> <20100408193838.GY10103@kernel.dk>
In-Reply-To: <20100408193838.GY10103@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004091052.32518.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 April 2010 01:08:38 Jens Axboe wrote:
> On Thu, Apr 08 2010, Tvrtko Ursulin wrote:
> > On Thursday 08 April 2010 13:45:39 Jens Axboe wrote:
> > > On Thu, Apr 08 2010, Nikanth Karthikesan wrote:
> > > > Update mtime when writing to backing filesystem using the address
> > > > space operations write_begin and write_end.
> > >
> > > You forgot to include a 'why' :-)
> > >
> > > Not that I disagree with the patch, just curious what made you make the
> > > change.
> >

Sorry, for the bad terse changelog.

> > You mean how the bug was found? I originally reported this problem
> > against openSUSE 11.2 kernel, where when you have a dm-crypt loop
> > filesystem the container file modification time does not get updated with
> > use. Consequence of that is that backup runs would miss the fact
> > container has changed.
> >
> > Maybe one could argue it is a security feature in this scenario :), but
> > as the problem turns out to be unrelated to the crypto case, rather
> > contained in the loop driver itself, it looks like that would not hold.
> >
> :-)
> 
> I suppose you could update the mtime on tear down, since then it would
> also be safe to actually backup. But same difference in the end I
> suppose, I'll add the patch.
> 

If we update mtime only during tear down, we might miss to backup after a 
system crash or scenarios where the loop device is not deleted after use 
during backup. Also when relatime is used, it is better to change mtime on 
time. :-)

Thanks for taking the patch.

Thanks
Nikanth
