Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AXNJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 08:09:37 -0500
Received: from www.tglx.de ([62.245.132.106]:59998 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1AXNJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:09:36 -0500
Date: Mon, 24 Jan 2011 14:09:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: torbenh <torbenh@gmx.de>
cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: [PATCH 09/18] frv: switch do_timer() to xtime_update()
In-Reply-To: <20110124125152.GA29377@siel.b>
Message-ID: <alpine.LFD.2.00.1101241400170.31804@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de> <1295651224-29823-10-git-send-email-torbenh@gmx.de> <alpine.LFD.2.00.1101221051570.2971@localhost6.localdomain6> <20110124125152.GA29377@siel.b>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, torbenh wrote:
> On Sat, Jan 22, 2011 at 11:01:49AM +0100, Thomas Gleixner wrote:
> > On Sat, 22 Jan 2011, Torben Hohn wrote:
> > 
> > > this code looks like its protecting __set_LEDS() with this lock also.
> > > i dont think thats necessary.
> > 
> > This changelog is horrible. 
> 
> agreed.
> what i meant was that: if i do something while holding a lock,
> it seems to be necessary to do it while holding the lock.

Well, it might be that way, but obviously that's not the case with the
code which is in the xtime lock write locked region (except for the
do_timer() call). :)
 
> > Also all arch/* patches are missing a "Cc: arch-maintainer@somewhere.xxx".
> 
> i was planning to send it out with --cc-cmd=./scripts/get_maintainers.pl
> once you thought it was ok.
> is that procedure ok ?

get_maintainers creates ugly long cc lists. I prefer hand selected
cc's. For the arch specific changes cc'ing only the relevant
maintainer (retrieved from MAINTAINERS) is enough.

> or should i add CC: lines to the commitlogs ?

Either way works. If I pick up such a series, my scripts generate the
Cc list in the changelog from the mail CC list.

Thanks,

	tglx
