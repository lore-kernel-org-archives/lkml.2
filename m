Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1EXLc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 07:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab1EXLc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 07:32:56 -0400
Date: Tue, 24 May 2011 13:32:43 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Lukas Czerner <lczerner@redhat.com>, Kyungmin Park <kmpark@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
In-Reply-To: <87y61wic4h.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.1105241319340.4028@dhcp-27-109.brq.redhat.com>
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de> <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com> <201103301706.36214.arnd@arndb.de> <BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com> <87wrhgk8lp.fsf@devron.myhome.or.jp>
 <BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com> <87r57ok3fp.fsf@devron.myhome.or.jp> <BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com> <87mxick0zj.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241102200.5457@dhcp-27-109.brq.redhat.com>
 <874o4kjtsy.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241211100.4028@dhcp-27-109.brq.redhat.com> <87y61wic4h.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, OGAWA Hirofumi wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> >> No. If you want to trim whole with some chunk like 1GB and periodically
> >> (IIRC in xfstest), what do? We have to trim until ULLONG_MAX for each
> >> 1GB?
> >> 
> >> Thanks.
> >> 
> >
> > What ? No, of course not. As I said, just go through 1G worth of filesystem
> > blocks skipping metadata. However we do have a special case when we
> > adjust start and len according to the first data block (which is only
> > the case of 1024B blocksize).
> >
> > 	if (start < first_data_blk) {
> > 		len -= first_data_blk - start;
> > 		start = first_data_blk;
> > 	}
> >
> > Which means that we just skip the first block (or whatever first data
> > block is). And this is the same as skipping metadata.
> 
> Are you read my email? So, FAT adjust 2 blocks, ext* 1 block, and what
> is other? The middle was guaranteed as continued? So, which is end of
> blocks?

I am sorry but I am not sure what you are asking for. Just grab the size
of the file system or even better the size of underlying device (since
the filesyste would not be bigger than that) and use that.

Of course if you grab the count of filesystem blocks (and the file
system does not account for the first data block) you'll end up with len
smaller than first data block. So it might make sense to not to
decrement the len and just start from first data block since it is not
accounted for anyway. However it is not a big deal, is it ? Are you
expecting any problems with this behaviour ?

-Lukas
