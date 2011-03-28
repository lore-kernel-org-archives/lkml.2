Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1C1Hda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:33:30 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:60484 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1C1Hd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:33:29 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v5] fat: Batched discard support for fat
References: <20110318020433.GA27263@july> <877hbkpo7v.fsf@devron.myhome.or.jp>
	<AANLkTimxojxAKbOE6XYa5DctNMpU8ob4+eAG05iwN=3P@mail.gmail.com>
	<874o6n6a0e.fsf@devron.myhome.or.jp>
	<AANLkTinTzj_BurexWAHa+EOt+GvpMB3Xm=GdtwdAt8i2@mail.gmail.com>
Date: Mon, 28 Mar 2011 16:33:25 +0900
In-Reply-To: <AANLkTinTzj_BurexWAHa+EOt+GvpMB3Xm=GdtwdAt8i2@mail.gmail.com>
	(Kyungmin Park's message of "Mon, 28 Mar 2011 15:56:42 +0900")
Message-ID: <87y63z4s3e.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

>> Yes. It's what I'm saying. If user wants to trim 0-2 then user will
>> specify 0-2, but this trims only 2. It's not right.
>
> There's similar code at ext4. it adjusts the start and len value if
> given start is less than first_data_blk.
>
>        if (start < first_data_blk) {
>                 len -= first_data_blk - start;
>                 start = first_data_blk;
>         }

Oh, strange design. On this design, user have to know which block is
actually start block per FSes (Yeah, you can still use this without
start block knowledge. But it's bogus). I think it should fix ext4. No?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
