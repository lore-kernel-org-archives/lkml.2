Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab1LOW7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:59:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51789 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503Ab1LOW7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:59:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111215144411.930dd860.akpm@linux-foundation.org>
References: <1323917052-480-1-git-send-email-walken@google.com>
	<20111215141945.add405d5.akpm@linux-foundation.org>
	<CANN689EViJYxDRr48wK1=_Lpb62wB5tj4-fnN1-MY8y-1L33fw@mail.gmail.com>
	<20111215144411.930dd860.akpm@linux-foundation.org>
Date: Thu, 15 Dec 2011 14:59:39 -0800
Message-ID: <CANN689HNM+01fXGNijNCgWtoGEGsxBz1Hi4Z+WNYe02EiREuyA@mail.gmail.com>
Subject: Re: [PATCH] Fix for binary_sysctl() memory leak
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 2:44 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> OK.  Please resend with a new changelog?

All right. Will do as a reply to this (I'll add the same explanation
as in my previous email).

> The bug surprises me - it seems that it makes it trivial for userspace
> to cause leaking of mad amounts of kernel memory, which would cause the
> bug to be found and fixed quickly.
>
> Is it a recent regression, or does the bug trigger only in weird
> circumstances, or what?

As far as I can tell, the bug was introduced in v2.6.33-rc1 by commit
26a7034b40ba80f82f64fa251a2cbf49f9971c6a

It's probably not common because people use sysctl mainly at boot
time, and/or don't use the deprecated binary variant of it anymore.
But yes, it is trivial to exploit...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
