Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0IOPPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:15:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440Ab0IOPP3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo> <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Sep 2010 08:14:49 -0700
Message-ID: <AANLkTikak7E1otZ3Uffiz2hRvOGrPe6kLcDp3tM69QM_@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 8:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Btw, please just do this as
>
>   if (copy_to)
>      ret = copy_from_user(..);
>   else
>      ret = copy_to_user(..);
>   kunmap(process_pages[i]);
>   if (ret)
>      goto out;

In fact, you might consider passing in a "copy_out" function pointer
rather than that "copy_to" boolean, and rather than that conditional,
just do a

  ret = copy_out(..);

thing. On sane/good architectures, branch target prediction will make
it all work out to the same work in the end, and it certainly looks
simpler and cleaner.

                                  Linus
