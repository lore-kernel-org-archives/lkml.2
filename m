Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578Ab2FGNSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:18:16 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:59292 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab2FGNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:18:15 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use test_and_clear_bit() instead atomic_dec_and_test() for stop_machine
References: <87likkt7u6.fsf@devron.myhome.or.jp>
	<87ehqct7a3.fsf@devron.myhome.or.jp>
	<20120522214633.GB30024@home.goodmis.org>
	<87aa0zty4r.fsf@devron.myhome.or.jp>
	<87mx4zr0l9.fsf@devron.myhome.or.jp>
	<1339073661.7559.1.camel@gandalf.stny.rr.com>
Date: Thu, 07 Jun 2012 22:18:08 +0900
In-Reply-To: <1339073661.7559.1.camel@gandalf.stny.rr.com> (Steven Rostedt's
	message of "Thu, 07 Jun 2012 08:54:21 -0400")
Message-ID: <877gvji7lb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Wed, 2012-05-23 at 13:19 +0900, OGAWA Hirofumi wrote:
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>> 
>> >> The down side to this is that it adds 4 more bytes on a 64bit
>> >> machine. (sizeof(unsigned log) == 8 and sizeof(atomic_t) == 4)
>> 
>> Another patch without additional 4bytes. This simply change
>> atomic_dec_and_test() to atomic_xchg().
>> 
>
> If nobody picked this up, you might want to resend it with my acked-by.
> (The second patch, not the first). As patches added to replies are
> usually ignored.

Thanks. I was going to add that to my personal patchset, I will try it again.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
