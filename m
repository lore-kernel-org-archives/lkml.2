Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1A1KqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 05:46:07 -0500
Received: from brother.balabit.com ([195.70.62.219]:37917 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab1A1KqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 05:46:05 -0500
X-Greylist: delayed 1466 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 05:46:05 EST
Subject: Re: Syslog-NG Fails as of Kernel 2.6.38-rc1
From: Gergely Nagy <algernon@balabit.hu>
To: linux-kernel@vger.kernel.org
In-Reply-To: <ihu3lv$921$4@dough.gmane.org>
References: <513567.89196.qm@web55903.mail.re3.yahoo.com>
	 <ihu3lv$921$4@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 11:21:36 +0100
Message-ID: <1296210096.24341.23.camel@moria>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The following appears in dmesg from kernels 2.6.38-rc1 to
> > 2.6.38-rc2-git5 (Not an issue in 2.6.37 stable):

[...]

> > ----------
> > ::Starting Syslg-NG            [BUSY] Error opening file for reading:
> > filename '/proc/kmsg', error='Operation not permitted (1)'
> > Error initializing source driver: source='src', id='src#2' Error
> > initializing message pipline;
> >                     [FAIL]

The problem is, that syslog-ng doesn't have the CAP_SYSLOG capability,
only CAP_SYS_ADMIN, which was enough pre-2.6.38. In 2.6.38+ however, one
needs CAP_SYSLOG (it was split out from CAP_SYS_ADMIN).

Which pretty much means that any userspace code that was using
CAP_SYS_ADMIN to access /proc/kmsg will have to be updated to use
CAP_SYSLOG (either instead, or in addition to CAP_SYS_ADMIN) in order to
work on new kernels.

I find that quite unfortunate, to be honest, as older applications that
aren't upgraded along with the kernel will simply break.

-- 
|8]


