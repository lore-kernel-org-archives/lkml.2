Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0KCRol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 13:44:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab0KCRoj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 13:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp>
References: <201011010053.ADE86905.JMLFHVtSQOOFOF@I-love.SAKURA.ne.jp> <201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Nov 2010 13:43:45 -0400
Message-ID: <AANLkTik_jP_Kvp6BUgdgNQaWAz2NzcPCK2=OMPOjRKOU@mail.gmail.com>
Subject: Re: [2.6.37-rc1] /proc/vmstat failure.
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: mrubin@google.com, fengguang.wu@intel.com, david@fromorbit.com,
        axboe@kernel.dk, kosaki.motohiro@jp.fujitsu.com,
        nickpiggin@yahoo.com.au, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 7:11 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> git bisect reported that commit 79da826aee6a10902ef411bc65864bd02102fa83
> "writeback: report dirty thresholds in /proc/vmstat" is first bad commit.

Have you verified that reverting that on top of current -git also
fixes the problem (outside of just the bisected kernels)?

> Steps to reproduce:
>  Boot and login via SSH and do "cat /proc/vmstat".
>
>  What is strange, this failure occurs when tty is /dev/pts/0 (i.e.
>  devpts filesystem / interactive ssh login session) and does not occur
>  when tty is /dev/tty1 (i.e. console login session).

It really sounds like memory corruption, likely because something has
stepped on somebody elses allocation. One thing that patch does is to
change the size of the allocation - perhaps it now ends up being in
the same bucket size with some tty data structure?

Have you tried enabling SLUB/SLAB debugging?

               Linus
