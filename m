Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1DVHAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 03:00:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:48377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab1DVHAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:00:35 -0400
Date: Fri, 22 Apr 2011 09:00:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at 0000000c IP: cfq_insert_request+0x1d/0x3f5
Message-ID: <20110422070032.GA3575@tiehlicka.suse.cz>
References: <20110420125824.GA3507@tiehlicka.suse.cz>
 <4DAEDBEB.7060904@fusionio.com>
 <20110420132903.GA13554@tiehlicka.suse.cz>
 <4DAF18DF.9080205@fusionio.com>
 <20110421071642.GA3556@tiehlicka.suse.cz>
 <5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk>
 <BANLkTinYv+YW6HVCodsWcCKwMmdZFsXPRA@mail.gmail.com>
 <20110421185112.GA4796@tiehlicka.suse.cz>
 <4DB07ECA.5050309@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB07ECA.5050309@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-04-11 21:00:26, Jens Axboe wrote:
> On 2011-04-21 20:51, Michal Hocko wrote:
> > On Thu 21-04-11 07:38:57, Linus Torvalds wrote:
> >> On Thu, Apr 21, 2011 at 12:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> I am going to bisect, let's see if I can find anything.
> >>>
> >>> Thanks, that would be great!
> >>
> >> I'd expect it to be very timing-dependent, and thus could easily be
> >> triggered (or hidden) by unrelated changes.
> >>
> >> Just happening to have a request added to the elevator at _just_ the
> >> same moment that another CPU is changing it and getting rid of the
> >> data structures for the old one.
> > 
> > And it really looks like a timing issue. I have bisected down to
> > e710d7d5a9cab1041b7a3cf9e655b75d92786857. I had to skip[1] some commits
> > due to compile errors [2].
> > At first it looked quite promising because I was able to boot after I
> > reverted that patch but then I have tried to revert it on top of rc4
> > (2f666bcf757cb72549f360ef6da02f03620a48b6) and saw the same problem
> > again.
> > 
> > So I do not think that bisecting will help here.
> 
> It will be timing dependent. If there's no allocated IO requests when
> the switch happens, it'll work.
> 
> But the commit that caused this regression is 5e84ea3a. If you revert
> that, it should work fine. Or just apply the patch I sent (or update to
> Linus' tree, it's in now) and it'll work as well.

Great. I can boot just fine with the current Linus tree
(2.6.39-rc4-00149-g91e8549).

Thanks a lot!
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
