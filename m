Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2BAP3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 10:29:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2BAP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 10:29:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] lkdtm: avoid calling lkdtm_do_action() with spin lock held
Date: Wed, 1 Feb 2012 15:29:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>
References: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com> <201201311535.53526.arnd@arndb.de> <4F28AB24.8050600@gmail.com>
In-Reply-To: <4F28AB24.8050600@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202011529.32778.arnd@arndb.de>
X-Provags-ID: V02:K0:0QZWDy3tb3Bm4FfqZ+rx3pZWxRqIiGx7gKeYjm9lj1f
 Sof6fVL4wFhltKm2WcGa8JCc4DggIUre4ozon1TsfyXtIxhTU3
 n0/IFMR8wSpgXsTahSCoaBAmhE3NTa9e7ufNSrbHFRWZpEivxg
 swOr9jSymCQAbArIjtQ8QcCqpStH2GIS5tczNMkzFv7zY8Ry41
 kHefqX6C7sq/oGzNHhxI+nbEruwdW3CPqaZOHMLkgH9n03J84Z
 yNyX6X+5x9n6SXGQvih+pACo9+HG1zUIihhbMjC9F3PuF6Byp9
 YhGbf7l165OPm1ZEAp2IKzTXonSXCJ3rQp7wkC1iSdIsUG5S0q
 MGcCZKOjRWkSCIjv4ldA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 February 2012, Cong Wang wrote:
> On 01/31/2012 11:35 PM, Arnd Bergmann wrote:
> > On Tuesday 31 January 2012, Cong Wang wrote:
> >> @@ -323,14 +323,16 @@ static void lkdtm_do_action(enum ctype which)
> >>          }
> >>          case CT_WRITE_AFTER_FREE: {
> >>                  size_t len = 1024;
> >> -               u32 *data = kmalloc(len, GFP_KERNEL);
> >> +               u32 *data = kmalloc(len, GFP_ATOMIC);
> >>
> >>                  kfree(data);
> >> -               schedule();
> >> +               udelay(100);
> >>                  memset(data, 0x78, len);
> >>                  break;
> >>          }
> >
> > I can't think of why the udelay would have any positive effect here,
> > if the idea of the schedule was to let some other process allocate and
> > use the memory.
> 
> 
> Hmm, on SMP udelay on this CPU will give a chance to other CPU's to use 
> that memory, right?
> 

There is a small chance for that, but it's much less likely than it would
be using another process on the same CPU, plus it requires SMP.

	Arnd
