Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab2ARQKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:10:04 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35848 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab2ARQKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:10:02 -0500
Date: Wed, 18 Jan 2012 08:09:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120118160957.GB30664@google.com>
References: <20120117214834.GD26207@google.com>
 <20120117220715.GB23527@redhat.com>
 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
 <20120118010323.GA32160@htj.dyndns.org>
 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
 <20120118011112.GB32160@htj.dyndns.org>
 <1326850253.22361.619.camel@sli10-conroe>
 <1326866602.22361.624.camel@sli10-conroe>
 <20120118135126.GB30204@redhat.com>
 <20120118142005.GC30204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118142005.GC30204@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 09:20:05AM -0500, Vivek Goyal wrote:
> > Not allocating icq if request is never going to go to elevator as elevator
> > switch was happening makes sense to me.
> > 
> > I tried this patch. It went little further and crashed at a different
> > place. I think this seems to be separate merging issue Tejun is trying
> > to track down.
> 
> Applied Tejun's debug patch to return early and not call into elevator
> for checking whether merge is allowed or not. Things seems to be stable
> now for me.

Yeah, plug merge is calling into elevator code without any
synchronization, so it's bound to be broken.  Given plugging is
per-task, I don't think we really need to query elevator about merging
bio's.  The request is not on elevator and plugging is part of issuing
mechanism, not scheduling, after all.  Jens, what do you think?

Thanks.

-- 
tejun
