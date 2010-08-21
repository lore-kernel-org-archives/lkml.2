Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab0HUAy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 20:54:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab0HUAy5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 20:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=iTY1LBE6F6u+e4mF61N6b_Sqdy2MBi6LJMQai@mail.gmail.com>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com> <AANLkTi=iTY1LBE6F6u+e4mF61N6b_Sqdy2MBi6LJMQai@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 17:54:07 -0700
Message-ID: <AANLkTik0v=FonpBzpRCxCrogL2KoPRQDT0X4BSbHx2cF@mail.gmail.com>
Subject: Re: [RFC] mlock/stack guard interaction fixup
To: Mike Snitzer <snitzer@gmail.com>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 5:20 PM, Mike Snitzer <snitzer@gmail.com> wrote:
>
> In 0002-mm-make-the-mlock-stack-guard-page-checks-stricter.patch you
> switch __mlock_vma_pages_range from 'start += PAGE_SIZE' to 'addr +=
> PAGE_SIZE'.
>
> So would that be a bugfix for commit d7824370?  Seems likely given
> start isn't used after that point.

Yup, that's a bug-fix. Although the real bug was having two variables
(addr and start) both be the same thing. Probably for some random
historical reason. And I didn't fix that.

                   Linus
