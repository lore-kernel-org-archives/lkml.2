Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2KRSqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 13:46:08 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56069 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2KRSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 13:46:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121118054510.GE16916@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk> <CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
 <CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
 <20121017160702.GY2616@ZenIV.linux.org.uk> <20121017161953.GZ2616@ZenIV.linux.org.uk>
 <CAHTX3dJN4Jun2KVXpda1wTrwkjT0mmH4fYmUUwq69d9sCTjXnA@mail.gmail.com>
 <20121115215529.GU2616@ZenIV.linux.org.uk> <CAHTX3d+Ou3_4tGqwyWFfNMSumPw2770_nhV_cTQa89k7+sxdHw@mail.gmail.com>
 <20121118054510.GE16916@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Nov 2012 08:45:43 -1000
X-Google-Sender-Auth: MY0sxc18bkbQAUz7mPMCgAX-kOQ
Message-ID: <CA+55aFxncW2pEhsjg0AO9YKyvPaHyiXZMjoJZ1J8gA+8sH7HNw@mail.gmail.com>
Subject: Re: sigaltstack fun (was Re: new execve/kernel_thread design)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 7:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Linus, do you have any objections to the above?  FWIW, I've a tentative
> patchset in that direction (most of it from the last cycle); right now
> it + stuff currently in signal.git#for-next is at -3.4KLoC and I hadn't
> dealt with the biarch side of things yet...

I have absolutely no objections. sigaltstack has always been kind of
messy, and made worse by the fact that it gets effectively no testing
(because it's generally not used by normal code and even code that
uses it tends to use it only for very uncommon events). So forcing all
the sigaltstack code into generic code and at least avoiding the
"different architectures can get things subtly - or not so subtly -
wrong in different ways" sounds like a good thing.

                   Linus
