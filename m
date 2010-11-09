Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0KIUaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:30:24 -0500
Received: from mail.perches.com ([173.55.12.10]:4781 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab0KIUaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:30:21 -0500
Subject: Re: [PATCH V2] include/linux/kernel.h: Move logging bits to
 include/linux/logging.h
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1289333413.28590.29.camel@Joe-Laptop>
References: <1289281110-8559-1-git-send-email-joe@perches.com>
	 <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com>
	 <1289328235.1823.108.camel@Joe-Laptop>
	 <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
	 <20101109200118.GA13016@core2.telecom.by>
	 <1289333413.28590.29.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 12:30:19 -0800
Message-ID: <1289334619.28590.39.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 12:10 -0800, Joe Perches wrote:
> On Tue, 2010-11-09 at 22:01 +0200, Alexey Dobriyan wrote:
> > Why linux_proc_banner is moved?
> It's only used by a printk.

Checking again, linux_proc_banner is only
used in one seq_printf and is not used in
a printk.

$ git grep -w linux_proc_banner *
fs/proc/version.c:      seq_printf(m, linux_proc_banner,
include/linux/logging.h:extern const char linux_proc_banner[];
init/version.c:const char linux_proc_banner[] =

I supposed it could be removed from kernel.h
or logging.h/printk.h and just declared extern
in fs/proc/version.c or moved to init.h or
maybe even version.h.

init.h already has other extern variables that
are declared in init/main.c so that might
make some sense.

