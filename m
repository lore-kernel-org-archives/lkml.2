Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1ANJiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:38:55 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40832 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1ANJit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:38:49 -0500
To: Nick Piggin <npiggin@gmail.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <AANLkTikVvaiqsj=ZiW4kN-CQB=oTuYpQQGH6+v6ZY1ny@mail.gmail.com>
	(message from Nick Piggin on Fri, 14 Jan 2011 19:52:27 +1100)
Subject: Re: Important for fs devs: rcu-walk merged upstream
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
	<E1PdOdT-00042k-RM@pomaz-ex.szeredi.hu>
	<E1PdPsR-0004BY-Q3@pomaz-ex.szeredi.hu>
	<AANLkTi=4mCaZzGXja0Z_VBS+fst8k8_=t1A-eZwfvKiA@mail.gmail.com>
	<E1PdfI0-0005U7-LU@pomaz-ex.szeredi.hu> <AANLkTikVvaiqsj=ZiW4kN-CQB=oTuYpQQGH6+v6ZY1ny@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1Pdg7I-0005Zl-Od@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 14 Jan 2011 10:38:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Nick Piggin wrote:
> On Fri, Jan 14, 2011 at 7:45 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Fri, 14 Jan 2011, Nick Piggin wrote:
> >> On Fri, Jan 14, 2011 at 3:18 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> >> Surely you'd need some filtering anyway? I don't think any function
> >> involving path lookup could sanely return -ECHILD.
> >
> > No, but not filtering doesn't normally hurt.  And it's not quite
> > trivial deciding what should be allowed and what shoudln't, and the
> > filter would have to be updated for each addition of a new errno.  So
> > I'm not sure I want to go there.
> 
> Well if you allow untrusted filesystems it is possible that
> -ECHILD return will do something a bit silly. So it would be
> good to filter it I guess.

What could it do (other than resulting in a silly error printout)?

If we'd want errno filtering for fuse how would you define "sane"?

> >> That said, it probably is a good idea to have a new errno.
> >
> > Yeah, that makes the fitering much easier.
> 
> How so? Would -ECHILD ever be sane to return? I'm not
> arguing against changing it but I just want to know what
> the issue is there.

All kernel private errnos are >=512 (see <linux/errno.h), filtering
out those is quite easy and clearly desirable.

Thanks,
Miklos
