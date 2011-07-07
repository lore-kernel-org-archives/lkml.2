Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1GGWzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:55:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303Ab1GGWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:55:09 -0400
Date: Thu, 7 Jul 2011 15:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergiu Iordache <sergiu@chromium.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] char drivers: ramoops debugfs entry
Message-Id: <20110707155426.fd95445f.akpm@linux-foundation.org>
In-Reply-To: <CAGDaqBQMp0xyBF7Z=P5qBqNcceG3JfWNEUX=T=yMZH74UP5kxA@mail.gmail.com>
References: <1309994990-4729-1-git-send-email-sergiu@chromium.org>
	<1309994990-4729-4-git-send-email-sergiu@chromium.org>
	<20110707130130.8dd02f01.akpm@linux-foundation.org>
	<CAGDaqBQMp0xyBF7Z=P5qBqNcceG3JfWNEUX=T=yMZH74UP5kxA@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 15:34:26 -0700
Sergiu Iordache <sergiu@chromium.org> wrote:

> On Thu, Jul 7, 2011 at 1:01 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, __6 Jul 2011 16:29:50 -0700
> > Sergiu Iordache <sergiu@chromium.org> wrote:
> >
> >> While ramoops writes to ram, accessing the dump requires using /dev/mem
> >> and knowing the memory location (or a similar solution). This patch
> >> provides a debugfs interface through which the respective memory
> >> area can be easily accessed.
> >>
> >> The entry added is /sys/kernel/debug/ramoops/next
> >>
> >> The entry returns a dump of size record_size each time, skipping invalid
> >> dumps. When it reaches the end of the memory area reserved for dumps it
> >> returns an empty record and resets the current record count.
> >
> > The patch increases the size of ramoops.o text&data from 1725 bytes to
> > 2282 even when CONFIG_DEBUG_FS=n. __That's quite a lot of bloat!
> >
> > Furthermore, I think debugfs is the wrong place to put this. __debugfs
> > is, umm, for debugging. __It's a place in which to put transitory junk
> > which may or may not be there and where interfaces may change without
> > notice and whose presence userspace should not assume. __But in this
> > patch you're proposing a permanent and formal new interface into the
> > ramoops driver. __It should go into a permanent well-known place where
> > it will be maintained with the formality and care of all the other
> > parts of the kernel API.
> How about not using the debugfs entry and adding a char driver? There
> are 2 possibilities here as well: using read operations to return the
> data like the current patch does or using ioctl to return the data(and
> maybe return other info as well such as the records size and the
> memory size). Any suggestions regarding a valid approach?

Well.  I haven't seen a description of what the interfaces *does* (and
I'm too obstinate to work that out from the patch) so it's hard to
advise.

ioctls are unpopular.

A char driver always seems weird and fake to me - there's no underlying
device.  /dev/zero considered harmful!

Perhaps switch it to sysfs?

