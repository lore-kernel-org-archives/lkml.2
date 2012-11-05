Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab2KEQ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:26:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55824 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2KEQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:26:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] drivers/misc/kgdbts.c: remove eprintk
Date: Mon, 5 Nov 2012 16:26:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: walter harms <wharms@bfs.de>, kernel-janitors@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <201211042051.58473.arnd@arndb.de> <alpine.DEB.2.02.1211042202240.1960@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1211042202240.1960@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211051626.29317.arnd@arndb.de>
X-Provags-ID: V02:K0:pbdcz8ac8cKrhcE5K65LJ7SrR7BOZRjorFkHIneyAJA
 pg8en6Ih5TFwym5CYhAV+oeuCPQcYEPwRMo4vlF4kPm77GNwfO
 Y5KwtoaFyojtQOxUhKET8M4huV5rpEnOD5et+NiPtUXUJnxoSl
 OcEwrdCPjhU7TPDh7UheELKYxxmY8FpL3ZylsPgF5wSGNNOLkC
 AFucgmXQd/iHtn5mT5S2dm1gxHjuZiSnI76yoM1BJXSa7WyM6K
 St/xPxCNSw2axLj52ImWNhLEeNTb3MopcLjFw9Th3OsO2iTCWt
 /QPXivySgAKrFFdH0VAY01gudvCcPkv63b6xrIaL+9wC4tKe0h
 0++3LpWGrHIilooDdwtw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 November 2012, Julia Lawall wrote:
> >
> > I don't see yet where that KERN_WARNING gets added. Looking at
> > warn_slowpath_common, there are two or three lines that get printed at
> > KERN_WARNING level, followed by the format that got passed into WARN(),
> > which may or may not include a printk level, but I don't see one getting
> > added.
> 
> OK, I agree.  There are lots of KERN_WARNINGs, but not on the string that 
> was passed in.  Still, maybe it is not so good to pass a KERN_XXX for some 
> other XXX to WARN.

Given that most users don't pass anything here, and that those that do pass
something are somewhat inconsistent, could we make the messages always get
printed at KERN_WARNING level from WARN(), and kill off the instances
that already pass a level?

	Arnd
