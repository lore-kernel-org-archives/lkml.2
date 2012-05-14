Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2ENKxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab2ENKxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:34 -0400
Date: Mon, 14 May 2012 12:53:18 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] Fix AFFS race condition.
Message-ID: <20120514105318.GH5353@quack.suse.cz>
References: <4FAFBAC1.20603@gmail.com>
 <20120514094543.GC5353@quack.suse.cz>
 <CANGUGtA=XfraVL28YqAM0t3oMjfud0Fn1VtJNxwt8=reG10nGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANGUGtA=XfraVL28YqAM0t3oMjfud0Fn1VtJNxwt8=reG10nGA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-05-12 12:40:45, Marco Stornelli wrote:
> 2012/5/14 Jan Kara <jack@suse.cz>:
> > On Sun 13-05-12 15:44:33, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> >> AFFS code preallocates several blocks as an optimisation. Unfortunately
> >> it's not protected by lock so the same blocks may end up allocated twice.
> >> Here is a fix.
> >>
> >> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
> >  The patch looks good to me now. Thanks! You can add:
> > Reviewed-by: Jan Kara <jack@suse.cz>
> >
> >  Al, will you merge this patch through your tree? AFFS does not seem to
> > have a maintainer so you are a default fallback...
> >
> >                                                                Honza
> >
> 
> I don't know the AFFS code, so only a question. Instead to use a spin
> lock, I think we can use a simple mutex. Or is the spin lock
> mandatory?
  So what would be an advantage of a mutex? Spinlock *is* the simple locking
variant...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
