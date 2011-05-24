Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1EXNaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab1EXNae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:30:34 -0400
Date: Tue, 24 May 2011 15:30:17 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Lukas Czerner <lczerner@redhat.com>, Kyungmin Park <kmpark@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
In-Reply-To: <87sjs4i93w.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.1105241520260.4028@dhcp-27-109.brq.redhat.com>
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de> <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com> <201103301706.36214.arnd@arndb.de> <BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com> <87wrhgk8lp.fsf@devron.myhome.or.jp>
 <BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com> <87r57ok3fp.fsf@devron.myhome.or.jp> <BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com> <87mxick0zj.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241102200.5457@dhcp-27-109.brq.redhat.com>
 <874o4kjtsy.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241211100.4028@dhcp-27-109.brq.redhat.com> <87y61wic4h.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241319340.4028@dhcp-27-109.brq.redhat.com> <87sjs4i93w.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, OGAWA Hirofumi wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> >> Are you read my email? So, FAT adjust 2 blocks, ext* 1 block, and what
> >> is other? The middle was guaranteed as continued? So, which is end of
> >> blocks?
> >
> > I am sorry but I am not sure what you are asking for. Just grab the size
> > of the file system or even better the size of underlying device (since
> > the filesyste would not be bigger than that) and use that.
> >
> > Of course if you grab the count of filesystem blocks (and the file
> > system does not account for the first data block) you'll end up with len
> > smaller than first data block. So it might make sense to not to
> > decrement the len and just start from first data block since it is not
> > accounted for anyway. However it is not a big deal, is it ? Are you
> > expecting any problems with this behaviour ?
> 
> What is size of file system or underlying devices? You force to find the
> device which target FS is using? Even if you can get size of underlying
> devices, you force to user to insane loop in size of devices?

Look, I do not have time to argue with you forever and I do not even
understand what is your point. Just go and read other filesystems
implementation of FITRIM (ext4,ext3,xfs,btrfs?) and you'll see what you
need to do.

If you do not want to get the file system size, then FINE! just pass the
damn UULONG_MAX as length. I have no clue what insane loop are you
talking about! It is *easy* just discard the whole thing (with
UULONG_MAX) or, if you want to do it per-partes, then do it as long as
it does not return EINVAL, once it does you know that your "start" is
out of the filesystem and you are done!


> 
> Why can you guarantee it's not big deal in design? Why can't you admit
> userland can't make optimized loop?

And what do you mean by that ?

-Lukas
