Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab0HQV65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:58:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54002
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab0HQV6w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:58:52 -0400
Date: Tue, 17 Aug 2010 14:59:08 -0700 (PDT)
Message-Id: <20100817.145908.112609486.davem@davemloft.net>
To: walken@google.com
Cc: torvalds@linux-foundation.org, tony.luck@intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: tasks getting stuck on mmap_sem?
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimLqc02xNun0QR5ZgP497mm8ZC5ZfpCUx2AGz4Y@mail.gmail.com>
References: <AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
	<AANLkTikcaVKnJxC18tUcJRTQwAukYhPdWMgGGrNaVjM_@mail.gmail.com>
	<AANLkTimLqc02xNun0QR5ZgP497mm8ZC5ZfpCUx2AGz4Y@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Lespinasse <walken@google.com>
Date: Tue, 17 Aug 2010 14:47:05 -0700

> On Tue, Aug 17, 2010 at 2:28 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Oh, and it strikes me when looking at the sparc rwsem-const.h that it
>> has some unsigned constants in it. I think
>>
>>  #define RWSEM_WAITING_BIAS              0xffff0000
>>
>> is actually unsigned, because it's a hex constant that doesn't fit in
>> a signed int. So it's of type 'unsigned int' if I recall the C type
>> rules right.
> 
> Eeeek, this totally escaped me when I had a quick look at constant
> signed-ness across architectures. This is definitely a problem.
> 
>> #define RWSEM_WAITING_BIAS             (-0x00010000)
> 
> David, do you still see failures with v2.6.36-rc1 plus that one line fix ?

As I said in a reply to Tony I don't even think your commit is
to blame, because even after reverting it I still have the
problems.

I'll keep digging into this.
