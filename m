Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0H3EVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 00:21:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59007
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404Ab0H3EVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 00:21:40 -0400
Date: Sun, 29 Aug 2010 21:21:56 -0700 (PDT)
Message-Id: <20100829.212156.229740543.davem@davemloft.net>
To: agruen@suse.de
Cc: eparis@parisplace.org, netfilter@vger.kernel.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org, schwab@redhat.com,
        tvrtko.ursulin@sophos.com
Subject: Re: aligned_{u64,be64,le64} defined in #ifdef __KERNEL__
From: David Miller <davem@davemloft.net>
In-Reply-To: <201008300326.30233.agruen@suse.de>
References: <1282682582-15980-1-git-send-email-eparis@redhat.com>
	<AANLkTimbQivEd7z1+sdLgChieGrY3c9iQWXVKgcYRAY=@mail.gmail.com>
	<201008300326.30233.agruen@suse.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>
Date: Mon, 30 Aug 2010 03:26:29 +0200

> On Saturday 28 August 2010 01:51:53 Eric Paris wrote:
>> I liked this version until I realized that userspace doesn't have
>> aligned_u64 as a valid type.
> 
> This looks like an error in include/linux/types.h.  The aligned types should 
> probably not be defined inside #ifdef __KERNEL__.

You can't do this, as it would pollute the POSIX namespace.

If we want a version of this type visible to userspace, it needs to,
for example, have double underscores prepended to the type name just
as we do for things like __u16 and __u32.
