Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab1EXOTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:19:07 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:36036 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab1EXOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:19:05 -0400
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
	<87sjs4i93w.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241520260.4028@dhcp-27-109.brq.redhat.com>
Date: Tue, 24 May 2011 23:19:00 +0900
In-Reply-To: <alpine.LFD.2.00.1105241520260.4028@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Tue, 24 May 2011 15:30:17 +0200 (CEST)")
Message-ID: <87oc2si3l7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

>> What is size of file system or underlying devices? You force to find the
>> device which target FS is using? Even if you can get size of underlying
>> devices, you force to user to insane loop in size of devices?
>
> Look, I do not have time to argue with you forever and I do not even
> understand what is your point. Just go and read other filesystems
> implementation of FITRIM (ext4,ext3,xfs,btrfs?) and you'll see what you
> need to do.
>
> If you do not want to get the file system size, then FINE! just pass the
> damn UULONG_MAX as length. I have no clue what insane loop are you
> talking about! It is *easy* just discard the whole thing (with
> UULONG_MAX) or, if you want to do it per-partes, then do it as long as
> it does not return EINVAL, once it does you know that your "start" is
> out of the filesystem and you are done!

You are not even understanding current implementations. See
ext3_trim_fs(), and ext4_trim_fs().

What happen if "start" was outside of max_blks:

ext3 returns 0
ext4 returns EINVAL

What means "start" is 0

ext3 maps to 1
ext4 just remove 0 from request

I missing something?

>> Why can you guarantee it's not big deal in design? Why can't you admit
>> userland can't make optimized loop?
>
> And what do you mean by that ?
>
> -Lukas

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
