Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2AIQUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:20:54 -0500
Received: from nm25-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.185]:22177 "HELO
	nm25-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932211Ab2AIQUw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:20:52 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 129682.8545.bm@omp1036.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=wjE/Nj/ACs0UNzYuRYYlSMkKREnKeeBohJjvXSazwNc1B7em53iejvos0C2o60kBsMjuRM1/hQFQSR7BfTX1mPKUOTli+gea28qK3IlFrQASQ+g+5zMK7+V7LwydAKTnkssXv799zN79ZSFctoXQmRobw0rQw0QYcqc6/g9PnJE=;
X-YMail-OSG: QWpjxgoVM1mHHaIQgJroLs0yiizD4Jl8Tl7ORrtg3l84xUL
 ql15QNr8_Giee2nvg_keZc9Rar8fUFirS.9CSFdar0LC0N0vWxLWGLd.JSUA
 QXMyps0KgL2dMqJrm18yUSZGAGRtgK5aflLVmiQfD1LZyeIf7H_vnNE8Jali
 UBzoQVcmUAzok9ikmBY_CarNQUUWQFFUgp3QzQL8SNfkip1N7OSolcW6KT1u
 x2nVqDT9wNUsLV0mZQWzsTlAyhCyP4aSk4FG0s8mSG67_7ntKUuRPbD8UZg0
 8Iy2UVFsVKAvkWNulo9InKLtQDz1cTHbl19xICBC7qPuIkeq4ilcZ4i5QW8u
 kl0ZiJ_IjjJeQEyyV4TxEoPbhEf4Mc6PGytiuOT8AqU5ufNikAVfPTQU4Jcn
 s_wLlAMrRF0QdAMblBjO4iuJAEADS42kjcRHNnWy70Hrigyp23BTriOSPazl
 qkJ1xdCkClKA9US.JoVvbPw--
X-Mailer: YahooMailWebService/0.8.115.331698
References: <1325993012.29526.YahooMailNeo@web38004.mail.mud.yahoo.com> <20120109151707.GB22175@thunk.org> <1326123988.9602.YahooMailNeo@web38004.mail.mud.yahoo.com> <20120109155016.GD22175@thunk.org>
Message-ID: <1326126051.97658.YahooMailNeo@web38008.mail.mud.yahoo.com>
Date: Mon, 9 Jan 2012 08:20:51 -0800 (PST)
From: Shantanu Goel <sgoel01@yahoo.com>
Reply-To: Shantanu Goel <sgoel01@yahoo.com>
Subject: Re: [PATCH] ext4: Fix up range_end offset in range cyclic writeback
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20120109155016.GD22175@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> So this was a performance issue that led you to this investigation?
> How much of a performance issue are we talking about?

It's a performance issue in the sense that background flush of the file can take much longer (we observed > 5 mins in some instances) than the 30 second kupdate interval.

> If it's a correctness issue that might lead to data loss because
> fsync() wasn't doing its jobs, that's obviously higher priority than a
> performance issue.

fsync() is not affected and works correctly with or without the patch since it does not use the range_cyclic writeback mode, AFAICT.  The only "correctness" issue would be if an application relies on kupdate which uses range_cyclic writeback to periodically flush the file as governed by the /proc/sys/vm/dirty_writeback_centisecs tunable.  We have some applications which lost more data than they expected due to the writeback not happening at expected intervals.  One could argue the bug is in the application since it could have guaranteed the file was flushed by using fsync hence my quotes around correctness.  Unfortunately, modifying the application is not an easy option for us to pursue at this time.  We just wish to have the patch merged upstream and the exact timing is not that critical.

> Again, I just wanted to characterize this correctly in the commit ---
> BTW, this is good stuff to include in the commit description so in the
> future, developers trying to go through the history can understand why
> a particular patch is important (perhaps to backport into an
> enterprise distro release, etc.)

Sure, will do in future.

Thanks,
Shantanu
