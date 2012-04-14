Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2DNNMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 09:12:46 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49081 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2DNNMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 09:12:44 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: dedekind1@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	<1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	<87fwc6hazv.fsf@devron.myhome.or.jp> <1334399379.2263.8.camel@koala>
	<87bomuha77.fsf@devron.myhome.or.jp> <1334401307.2263.24.camel@koala>
	<873986h6qa.fsf@devron.myhome.or.jp> <1334406974.2263.38.camel@koala>
Date: Sat, 14 Apr 2012 22:12:39 +0900
In-Reply-To: <1334406974.2263.38.camel@koala> (Artem Bityutskiy's message of
	"Sat, 14 Apr 2012 15:36:11 +0300")
Message-ID: <87y5pyfoe0.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:

> On Sat, 2012-04-14 at 20:51 +0900, OGAWA Hirofumi wrote:
>> Yes, I still worry about order. About ->sync_fs(), you are looking the
>> following?
>
> Hirofumi, you still did not explain why the order matters. If it
> matters, it should be easy to explain.
>
> But I will look at this and think about the ordering, thanks for
> feed-back. But if you could explain why writing out FSINFO before inodes
> is an issue, it'd be very helpful.

Hm, you want to this one?

If fsinfo is inode, the order can be

1) flush inodes
    1a) flush fsinfo inode
    1b) flush normal inodes
2) last iput(normal inodes)
      truncate()
           dirty fsinfo inode
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
