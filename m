Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab1D2QbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:31:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1D2QbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:31:20 -0400
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
From: James Bottomley <James.Bottomley@suse.de>
To: sedat.dilek@gmail.com
Cc: Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304091436.2559.8.camel@mulgrave.site>
References: <1303920553.2583.7.camel@mulgrave.site>
	 <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site>
	 <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site>
	 <BANLkTimpMJRX0CF7tZ75_x1kWmTkFx3XxA@mail.gmail.com>
	 <1304091436.2559.8.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 11:31:12 -0500
Message-ID: <1304094672.2559.12.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 10:37 -0500, James Bottomley wrote:
> On Fri, 2011-04-29 at 12:23 +0200, Sedat Dilek wrote:
> > But as I see these RCU (CPU) stalls, the patch from [1] might be worth a try.
> > First, I have seen negative effects on my UP-system was when playing
> > with linux-next [2].
> > It was not clear what the origin was and the the side-effects were
> > somehow "bizarre".
> > The issue could be easily reproduced by tar-ing the kernel build-dir
> > to an external USB-hdd.
> > The issue kept RCU and TIP folks really busy.
> > Before stepping 4 weeks in the dark, give it a try and let me know in
> > case of success.
> 
> Well, it's highly unlikely because that's a 2.6.39 artifact and the bug
> showed up in 2.6.38 ... I tried it just in case with no effect, so we
> know it isn't the cause.

Actually, I tell a lie: it does't stop kswapd spinning on PREEMPT, but
it does seem to prevent non-PREEMPT from locking up totally (at least it
survives three back to back untar runs).

It's probable it alters the memory pin conditions that cause the spin,
so it's masking the problem rather than fixing it.

The question now is, what causes it in 2.6.38 stable?

James


