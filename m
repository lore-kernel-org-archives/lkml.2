Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0HQXj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:39:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40813
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab0HQXjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:39:55 -0400
Date: Tue, 17 Aug 2010 16:40:13 -0700 (PDT)
Message-Id: <20100817.164013.193700583.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: tony.luck@intel.com, walken@google.com, dhowells@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: tasks getting stuck on mmap_sem?
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikcaVKnJxC18tUcJRTQwAukYhPdWMgGGrNaVjM_@mail.gmail.com>
References: <AANLkTinO5yip7agVO3Lq3YLjDYmkB9MP14xjt3TusMfW@mail.gmail.com>
	<AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
	<AANLkTikcaVKnJxC18tUcJRTQwAukYhPdWMgGGrNaVjM_@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 14:28:49 -0700

> Oh, and it strikes me when looking at the sparc rwsem-const.h that it
> has some unsigned constants in it. I think
> 
>   #define RWSEM_WAITING_BIAS              0xffff0000
> 
> is actually unsigned, because it's a hex constant that doesn't fit in
> a signed int. So it's of type 'unsigned int' if I recall the C type
> rules right.

You were right all along, of course.  Nice spotting.

Something was messed up with my testing methodology last night such
that I didn't test the revert of the lib/rwsem.c changes properly.
Those actually did in fact introduce the problem.

And fixing these sparc rwsem values to be signed constants fixes the bug.

Thanks guys.
