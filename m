Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2ASBoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:44:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37549 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2ASBoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:44:00 -0500
Date: Wed, 18 Jan 2012 17:43:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch]block: fix NULL icq_cache reference
Message-ID: <20120119014356.GF21533@google.com>
References: <20120117214834.GD26207@google.com>
 <20120117220715.GB23527@redhat.com>
 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
 <20120118010323.GA32160@htj.dyndns.org>
 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
 <20120118011112.GB32160@htj.dyndns.org>
 <1326850253.22361.619.camel@sli10-conroe>
 <1326866602.22361.624.camel@sli10-conroe>
 <20120118160713.GA30664@google.com>
 <1326937294.22361.649.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326937294.22361.649.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 19, 2012 at 09:41:34AM +0800, Shaohua Li wrote:
> > Hmmm... but I'm having a difficult time following the description.
> > Maybe we can simplify a bit?  e.g. sth like the following?
> > 
> >   Once a queue is quiesced, it's not supposed to have any elvpriv data
> >   or icq's, and elevator switching depends on that.  Request alloc
> >   path followed the rule for elvpriv data but forgot apply it to
> >   icq's leading to the following crash during elevator switch.
> > 
> >   <oops log>
> > 
> >   Fix it by not allocating icq's if ELVPRIV is not set for the
> >   request.
>
> I'm trying to explain why there is a crash, but fine to use your
> description.

Yeah, giving details is great.  It just seemed that high level
description seemed lost among the details.  It would have been great
if the description started with high level description and then went
into details.

> Once a queue is quiesced, it's not supposed to have any elvpriv data or
> icq's, and elevator switching depends on that.  Request alloc path
> followed the rule for elvpriv data but forgot apply it to icq's
> leading to the following crash during elevator switch. Fix it by not
> allocating icq's if ELVPRIV is not set for the request.
> 
> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Tested-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot.

-- 
tejun
