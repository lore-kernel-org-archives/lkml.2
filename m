Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0FISyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:54:10 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35685 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab0FISyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:08 -0400
Date: Wed, 9 Jun 2010 11:54:03 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] floppy: cleanup patches
Message-ID: <20100609115403.75ebb6cb@nehalam>
In-Reply-To: <alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
References: <20100609183449.110905403@vyatta.com>
	<alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 11:46:13 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 9 Jun 2010, Stephen Hemminger wrote:
> >
> > When going through floppy driver addressing some of the timing
> > bugs, I also saw these leftover things that ought to be cleaned up.
> 
> Ack on them all as far as I'm concerned. I suspect the _real_ bugs in 
> floppy.c are about various paths not holding the floppy_lock spinlock, but 
> the patches all look fine and certainly don't make anything worse.
> 
> Mind re-sending them after 2.6.35, though? (Or maybe somebody like Greg 
> wants to queue them up in their drievr trees)
> 
> 			Linus

Current plan is to convert all the timers and old BH code to go through
a single workqueue. This avoids all the races and cleans up the cancellation
logic as well without having lots of other changes.

-- 
