Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0KYPOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:14:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0KYPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:14:43 -0500
Date: Thu, 25 Nov 2010 10:14:36 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: mmotm 2010-11-23 - WARNING: at drivers/tty/tty_io.c:1331
Message-ID: <20101125151436.GG22651@bombadil.infradead.org>
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
 <5747.1290574539@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5747.1290574539@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 11:55:39PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 23 Nov 2010 16:13:06 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-11-23-16-12 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Seen during boot:
> 
> [   23.015448] Modules linked in:
> [   23.015453] Pid: 1207, comm: plymouthd Not tainted 2.6.37-rc3-mmotm1123 #3
> [   23.015455] Call Trace:

I've been trying to figure this one out for a while, without much luck.
(Users are seeing it in 2.6.36 as well.)

I *think* (I added a rawhide debugging patch to print the tty->name)
that plymouth is always opening tty7 to cause this. My guess is the BKL
removal has exposed some kind of race, but it's not obvious to me (and
there's many other bugs to sort through too. :(

CC-ing Jiri since he seems to be the poor guy who's been poking this
recently (there's a good few threads about this (though the others look
like an ldisc attach race...)) I wouldn't think that's the case here
since N_TTY is the default...

--Kyle
