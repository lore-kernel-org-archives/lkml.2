Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0KAICJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 04:02:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48762 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0KAICH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 04:02:07 -0400
Date: Mon, 1 Nov 2010 08:02:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/6] avr32: get rid of useless args in signal.c before
 other work there
Message-ID: <20101101080201.GZ19804@ZenIV.linux.org.uk>
References: <E1P0QNo-0008S7-Vr@ZenIV.linux.org.uk>
 <1288598309.2843.12.camel@hcegtvedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288598309.2843.12.camel@hcegtvedt>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 08:58:29AM +0100, Hans-Christian Egtvedt wrote:
> On Tue, 2010-09-28 at 03:57 +0100, Al Viro wrote: 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> <snipp>
> 
> > @@ -261,11 +261,12 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
> >   * doesn't want to handle. Thus you cannot kill init even with a
> >   * SIGKILL even by mistake.
> >   */
> > -int do_signal(struct pt_regs *regs, sigset_t *oldset, int syscall)
> > +static void do_signal(struct pt_regs *regs, int syscall)
> >  {
> >  	siginfo_t info;
> >  	int signr;
> >  	struct k_sigaction ka;
> > +	sigset_t *oldset;
> 
> Should be initialized as it is checked in the else if block further
> below.

That else if should be simply else...
