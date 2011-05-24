Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1EXErx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:47:53 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:58193 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1EXErv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:47:51 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Lukas Czerner <lczerner@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de>
	<AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
	<201103301706.36214.arnd@arndb.de>
	<BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com>
Date: Tue, 24 May 2011 13:47:46 +0900
In-Reply-To: <BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com> (Kyungmin
	Park's message of "Tue, 24 May 2011 10:18:20 +0900")
Message-ID: <87wrhgk8lp.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

> Hi again,

Hi

> Do you still object to merge this feature for .40? As I said the
> batched discard design is out-of-scope of this patch.
> It's implemented at other batched discard, ext4, xfs and so on.
>
> I hope fat is also support the batched discard.
>
> Any opinions?

I'm also thinking implementing this is good though. Sorry, I'm not going
to apply this for now, and would like to wait to be used by real
userland (I hope guys notice the problem, or userland tackles it somehow
sadly).

I think, to expose the wrong behavior like this would be worse.

E.g. one of problems, userland might do like this (trim chunk from 0 to
number of block)

for chunk in number_of_blocks
	do_trim chunk
done

But this is actually wrong, this interface doesn't map blocks to 0-max,
so userland have to know real maximum-block-number somehow for each FS
(and maybe have to know real minimum-block-number).

So, how to fix this? The solutions would be userland workaround, or fix
kernel. If it was userland, userland have to know FS internal sadly. If
it was kernel, we would have backward compatible nightmare, or ignore
compatible :(.

I really think we have to rethink this and have agreement about common
interface. Or there was real userland app, I think FAT can implement to
work that app.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
