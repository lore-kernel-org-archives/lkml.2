Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab1AYKVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:21:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36596 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab1AYKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gYBm9JQXEtql7j1tE4ydlQNohGfc5PlD1AN4Tz+VKjtMHxZQD1trK/lQ65ARtneJBL
         CNNcRhWr1Vub/CKYkfUmOQ2GFKXVoJ6Rl2TTC1KKabhJfd8iq4LQrgxeqAfrV1UmvD2J
         hbavQJy9P+jgX3tUxKlu5gvEnwZWZ/8HaNvtI=
Date: Tue, 25 Jan 2011 11:21:28 +0100
From: Tejun Heo <tj@kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, tytso@mit.edu,
        shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        snitzer@redhat.com, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
        cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
        hch@lst.de, josef@redhat.com
Subject: Re: [PATCH 3/3] block: reimplement FLUSH/FUA to support merge
Message-ID: <20110125102128.GO27510@htj.dyndns.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
 <1295625598-15203-4-git-send-email-tj@kernel.org>
 <20110121185617.GI12072@redhat.com>
 <20110123102526.GA23121@htj.dyndns.org>
 <20110124203155.GA32261@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124203155.GA32261@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Darrick.

On Mon, Jan 24, 2011 at 12:31:55PM -0800, Darrick J. Wong wrote:
> > So, I think it's better to start with something simple and improve it
> > with actual testing.  If the current simple implementation can match
> > Darrick's previous numbers, let's first settle the mechanisms.  We can
> 
> Yep, the fsync-happy numbers more or less match... at least for 2.6.37:
> http://tinyurl.com/4q2xeao

Good to hear.  Thanks for the detailed testing.

> I'll give 2.6.38-rc2 a try later, though -rc1 didn't boot for me, so these
> numbers are based on a backport to .37. :(

Well, there hasn' been any change in the area during the merge window
anyway, so I think testing on 2.6.37 should be fine.

> > I don't really think we should design the whole thing around broken
> > devices which incorrectly report writeback cache when it need not.
> > The correct place to work around that is during device identification
> > not in the flush logic.
> 
> elm3a4_sas and elm3c71_extsas advertise writeback cache yet the
> flush completion times are suspiciously low.  I suppose it could be
> useful to disable flushes to squeeze out that last bit of
> performance, though I don't know how one goes about querying the
> disk array to learn if there's a battery behind the cache.  I guess
> the current mechanism (admin knob that picks a safe default) is good
> enough.

Yeap, that or a blacklist of devices which lie.

Jens, what do you think?  If you don't object, let's put this through
linux-next.

Thank you.

-- 
tejun
