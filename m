Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1CYRYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:24:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59753 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1CYRYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=azyASZt29myKyscPQOJ1Gg1b++tlyJk4sd8/pZY57mAyhaTeZQ/Hrz3o2QrxUzKEOc
         EYuw29j6AM71FeuBAgh9nXroPVAi/dGXmeFuHI0rGmlfPK0mE1zO761fgCTx0oYwXASI
         HMLcgmQR6P8L3JWsDezEMVRzgT/owBaOQZqps=
Date: Fri, 25 Mar 2011 18:24:46 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [GIT PULL] ext4 update for 2.6.39-rc1
Message-ID: <20110325172446.GH1409@htj.dyndns.org>
References: <E1Q2wpD-0002It-CE@tytso-glaptop>
 <AANLkTi=aKLhtuuMtd=KZ8YBykCp=yJ-KPAJ3jKQq0jQW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=aKLhtuuMtd=KZ8YBykCp=yJ-KPAJ3jKQq0jQW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Fri, Mar 25, 2011 at 10:02:48AM -0700, Linus Torvalds wrote:
> Ok, guys, can you verify my merge? In one branch, we had Tejun change
> it to use "alloc_workqueue()", and in another, ext4 switched from
> create_workqueue() to create_singlethread_workqueue().
> 
> My resolution was to use WQ_UNBOUND in allow_workqueue() in the
> resulting merge, which I think should be semantically the correct
> resolve. But the commit message in the create_singlethread_workqueue()
> change seems to imply that the single-threadedness isn't a
> _correctness_ issue as much as it is just a "we don't need multiple
> threads" issue, so maybe the WQ_UNBOUND isn't necessary. So WQ_UNBOUND
> may or may not be a good idea.
> 
> Regardless, please give it a look, ok?

The merg should be safe but WQ_UNBOUND isn't necessary there, so I
think the version from commit fd89d5f2030a ("ext4: convert to
alloc_workqueue()") would be better.  BTW, Stephen already spotted
this earlier today - https://lkml.org/lkml/2011/3/24/652

Thanks.

-- 
tejun
