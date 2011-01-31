Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1AaUOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:14:20 -0500
Received: from webbox4.loswebos.de ([213.187.93.205]:36096 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1AaUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:14:19 -0500
Date: Mon, 31 Jan 2011 21:14:15 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Gergely Nagy <algernon@balabit.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Syslog-NG Fails as of Kernel 2.6.38-rc1
Message-ID: <20110131201415.GB30479@marc.osknowledge.org>
References: <513567.89196.qm@web55903.mail.re3.yahoo.com>
 <ihu3lv$921$4@dough.gmane.org>
 <1296210096.24341.23.camel@moria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296210096.24341.23.camel@moria>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.37-ck1-dezzy
User-Agent: Mutt/1.5.21hg (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gergely Nagy <algernon@balabit.hu> [2011-01-28 11:21:36 +0100]:

I wonder why Linus himself didn't come up on this. I remember him saying that
breaking userspace is crap a thousand times. And this thing here bugs me a lot!

As far as I remember the kmsg rights-thing was only for some just-in-case attack
scenario - what's absolutely _no_ reason to break userspace _now_.

Regards,
	Marc

> > > The following appears in dmesg from kernels 2.6.38-rc1 to
> > > 2.6.38-rc2-git5 (Not an issue in 2.6.37 stable):
> 
> [...]
> 
> > > ----------
> > > ::Starting Syslg-NG            [BUSY] Error opening file for reading:
> > > filename '/proc/kmsg', error='Operation not permitted (1)'
> > > Error initializing source driver: source='src', id='src#2' Error
> > > initializing message pipline;
> > >                     [FAIL]
> 
> The problem is, that syslog-ng doesn't have the CAP_SYSLOG capability,
> only CAP_SYS_ADMIN, which was enough pre-2.6.38. In 2.6.38+ however, one
> needs CAP_SYSLOG (it was split out from CAP_SYS_ADMIN).
> 
> Which pretty much means that any userspace code that was using
> CAP_SYS_ADMIN to access /proc/kmsg will have to be updated to use
> CAP_SYSLOG (either instead, or in addition to CAP_SYS_ADMIN) in order to
> work on new kernels.
> 
> I find that quite unfortunate, to be honest, as older applications that
> aren't upgraded along with the kernel will simply break.
> 
> -- 
> |8]
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Marc Koschewski
