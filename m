Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab1EWIKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:10:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:46089 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab1EWIKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:10:17 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Date: Mon, 23 May 2011 10:12:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "D. Jansen" <d.g.jansen@googlemail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <BANLkTikVLFMX_U6brQ5OALbvJkOGuz6++Q@mail.gmail.com> <20110522004833.GY32466@dastard>
In-Reply-To: <20110522004833.GY32466@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105231012.06928.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 22. Mai 2011, 02:48:33 schrieb Dave Chinner:
> On Fri, May 20, 2011 at 08:01:17AM +0200, D. Jansen wrote:
> > On Fri, May 20, 2011 at 5:39 AM, Dave Chinner <david@fromorbit.com> wrote:

> > 1. I thought I (may) make that decision by using laptop mode.
> 
> Laptop mode does not change fsync guarantees, so no, you ar enot
> making a decision to throw data away when you select laptop mode.

You do however decide to sync less often, resulting in a potentially
larger loss of data.

> > 3. A lib doesn't fix the ordering guarantee problem.
> 
> A properly implemented filesystem will not have ordering problems
> just because fsyncs are not issued.

But user space will have this problem. A single task's sequence of
write(); fsync(); write(); does give an implicit guarantee of ordering
to user space. To keep that guarantee, you need kernel support,
because only the kernel can issue the necessary barrier/flush commands.
A filesystem is not required to make sure your writes hit the disk
in the order you issued them, unless you use fsync, which gives
an even larger guarantee, but also implies ordering.

Now you may say that you want full fsync or nothing, but this is a personal
preference.

	Regards
		Oliver
