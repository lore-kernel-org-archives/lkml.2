Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0ETRkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:40:21 -0400
Received: from n22.bullet.mail.mud.yahoo.com ([68.142.206.161]:21563 "HELO
	n22.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752613Ab0ETRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:40:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 118336.51701.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=rNd3pVBm21lWTxcQrChn1mSxWDdvjymroNcU8HeVWJzDzyoGRpmOwEijFCK1XgZlbZqNupkfnqvGsj+6fOkW4tfQqPXkXQGOCJuhIPEaYKaPmyQVaNFL1qiLE/lE8V4zZdXiv2HRiKmoHOkFx6msUuyIAM2LYPYW8TGQoAJx0/8=;
Message-ID: <15003.23611.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: KPE0xPoVM1k5SZHimwZz7JuyVZcZJac6nb24HA4427y7eFM
 o2bmXkx2kp4lahXp40dGTf6B4XvfTGBIOwQg72q7TC0yKvuULMJdhMobkAJd
 e9QvwvaYMwdZR_eY2uKtYEXZvMU32Fyjvltohn6QvGI2tAvbRFa5hx60mnaB
 fO0dRjWHt7uGItzJWBkwrC7Az0sScOrV.9kpXnbrAbYi4O3FlGA6aSnCyvbX
 oS8cEfOMLyB7q.YwznMx3ViZ5AUvqmkN6dsLuIJe1FuiYaJrPuECLdwP3I9z
 0aocbJJXhErEwZK2THSbJxxtGMd2f.Qu.KKSpo_FBXOtdCLXbpdHWupM-
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Thu, 20 May 2010 10:40:17 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
To: felipe.balbi@nokia.com, Vladimir Pantelic <pan@nt.tu-darmstadt.de>
Cc: Matthew Garrett <mjg@redhat.com>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Brian Swetland <swetland@google.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <4BF51C9D.8050406@nt.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > during development on MeeGo devices we try to tackle
> down as much as
> > possible the use_time offenders and start by filing
> bugs to those apps,
> > instead of fixing their issues in kernel space.

Some apps do abuse kernel mechanisms, and whether the bug is in the
app or that kernel mechanism can be a judgement call.  I'd expect to
see some fixes be appropriately in-kernel; maybe not many though.

When reading about this suspend block stuff, does anyone else hear
eachoes of APM?  It's been ages since that was used, but ISTR it also
leveraged handshaking between kernel and userspace.  Are there lessons
to be applied from there to this discussion?

On first principles, I don't see anything wrong with acknowledging that
the kernel doesn't have a "whole system PM view" and thus its PM knowledge could usefully be augmented by information from userspace (applications), possibly on request.

Just what that broad PM view consists of gets kind of system-specific.  For OMAP hardware, with smart device-level power reduction active almost
all the time, it may look different from an ACPI laptop where the BIOS
is biased towards saving device power primarily in some suspend state(s) ... or some other hardware platform without much hardware or BIOS assist, where the main PM mechanisms involve software detection/instigation of hardware idleness (and potentially "off-ness").




> And you will continue doing that once the Meego app store
> has 100k apps?

I may have overlooked it, in one of the 100K messsages in my
mailbox about versions of suspend block/etc patches ...

But surely NOBODY is actually contending that broken aps NOT get fixed??

It's clear to me that tools are needed to identify power hogs; powertop can't be the extent of such tools.  (ISTR it doesn't monitor display power usage, for one thing; maybe newer versions do so.)  Once such hogs get identified they will need to get fixed.  Any other proposal seems broken to me...

