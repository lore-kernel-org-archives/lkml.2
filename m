Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1EXMTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:19:52 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:57514 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1EXMTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:19:51 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Kyungmin Park <kmpark@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de>
	<AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
	<201103301706.36214.arnd@arndb.de>
	<BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com>
	<87wrhgk8lp.fsf@devron.myhome.or.jp>
	<BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com>
	<87r57ok3fp.fsf@devron.myhome.or.jp>
	<BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com>
	<87mxick0zj.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241102200.5457@dhcp-27-109.brq.redhat.com>
	<874o4kjtsy.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241211100.4028@dhcp-27-109.brq.redhat.com>
	<87y61wic4h.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241319340.4028@dhcp-27-109.brq.redhat.com>
Date: Tue, 24 May 2011 21:19:47 +0900
In-Reply-To: <alpine.LFD.2.00.1105241319340.4028@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Tue, 24 May 2011 13:32:43 +0200 (CEST)")
Message-ID: <87sjs4i93w.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

>> Are you read my email? So, FAT adjust 2 blocks, ext* 1 block, and what
>> is other? The middle was guaranteed as continued? So, which is end of
>> blocks?
>
> I am sorry but I am not sure what you are asking for. Just grab the size
> of the file system or even better the size of underlying device (since
> the filesyste would not be bigger than that) and use that.
>
> Of course if you grab the count of filesystem blocks (and the file
> system does not account for the first data block) you'll end up with len
> smaller than first data block. So it might make sense to not to
> decrement the len and just start from first data block since it is not
> accounted for anyway. However it is not a big deal, is it ? Are you
> expecting any problems with this behaviour ?

What is size of file system or underlying devices? You force to find the
device which target FS is using? Even if you can get size of underlying
devices, you force to user to insane loop in size of devices?

Why can you guarantee it's not big deal in design? Why can't you admit
userland can't make optimized loop?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
