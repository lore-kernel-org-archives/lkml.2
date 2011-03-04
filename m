Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab1CDJzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:55:40 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57820 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1CDJzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:55:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 3/3] Check for write permission on FD based posix-clocks
Date: Fri, 4 Mar 2011 10:55:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, johnstul@us.ibm.com, tglx@linutronix.de
References: <1299173174-348-1-git-send-email-torbenh@gmx.de> <1299173174-348-4-git-send-email-torbenh@gmx.de> <20110304072239.GA8957@riccoc20.at.omicron.at>
In-Reply-To: <20110304072239.GA8957@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041055.27199.arnd@arndb.de>
X-Provags-ID: V02:K0:Bj4mYwHvbLOYot+z0okl22taLSh6pn2o+xQ4vkK9sxb
 GXJUti/TerhLtA5ApNqlK5+lG1cxJIR/Dk4MMcTRAL/zHXV6PG
 85rYDco7nmvGnLu0n9dO7rKb5xdGJCPnt5+rL4CTMwKYEeuGWh
 RFqroz/Sh+0ihxBFQF16igKrI/GXYMi4tM1R2FHafn8ImJTSAa
 lJO5fmCcMnCFS+AGhdSlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 March 2011 08:22:39 Richard Cochran wrote:
> > diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
> > index 04498cb..25028dd 100644
> > --- a/kernel/time/posix-clock.c
> > +++ b/kernel/time/posix-clock.c
> > @@ -287,11 +287,16 @@ static int pc_clock_adjtime(clockid_t id, struct timex *tx)
> >       if (err)
> >               return err;
> >  
> > +     if ((cd.fp->f_mode & FMODE_WRITE) == 0) {
> > +             err = -EACCES;
> 
> Looks like clock_settime and adjtimex are supposed to return EPERM in
> this case.
> 

I think both choices are correct:

EACCESS often refers to the file permissions of an inode or the mode
of an open file. EPERM usually means that an operation can only be
performed by the owner of an object or by root. So clock_settime and
adjtimex should return EPERM and pc_clock_adjtime should return EACCESS.

	Arnd
