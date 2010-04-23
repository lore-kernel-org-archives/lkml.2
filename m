Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab0DWFRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:17:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35074 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab0DWFRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:17:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Reimer <mattjreimer@gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while userspace is frozen?
Date: Fri, 23 Apr 2010 07:17:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
References: <Pine.LNX.4.44L0.1003032142580.6963-100000@netrider.rowland.org> <20100304201548.GA1341@elf.ucw.cz> <y2yf383264b1004221640rd1fca614zfa15d7e7984ab3ba@mail.gmail.com>
In-Reply-To: <y2yf383264b1004221640rd1fca614zfa15d7e7984ab3ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004230717.07086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 April 2010, Matt Reimer wrote:
> On Thu, Mar 4, 2010 at 1:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> > My thought exactly.  This is the only approach that also solves the
> >> > following race:
> >> >
> >> >     A driver is unloaded at the same time as a suspend starts.
> >> >
> >> >     The writeback thread gets frozen.
> >> >
> >> >     Then before the rmmod thread is frozen, it calls del_gendisk.
> >> >
> >> > Delaying things by means of a workqueue (or the equivalent) might also
> >> > work, but it doesn't seem as safe.  For example, some important
> >> > writebacks might end up getting delayed until too late.
> >
> > Delaying writebacks during sleep should be ok... That's why we do
> > sync() after userspace is frozen -- nothing really important should be
> > waiting for writeback after that point.
> 
> Has this been fixed,

No, it hasn't.

> or has a consensus about how to fix this been
> achieved? I'm hitting the same problem and have some time to work on a
> fix.

Generally, it looks like del_gendisk should thaw writeback threads, but not
during suspend, only during resume.

Rafael
