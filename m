Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0DHIIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 04:08:34 -0400
Received: from smtp.nokia.com ([192.100.105.134]:60184 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0DHII3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 04:08:29 -0400
Subject: Re: CONFIG_MTD_DEBUG vs generic DEBUG support in kernel.h
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <87vdctzjn4.fsf@tac.ki.iif.hu>
References: <878w9swhlv.fsf@tac.ki.iif.hu>
	 <1268744759.20017.58.camel@localhost>  <87vdctzjn4.fsf@tac.ki.iif.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Apr 2010 11:06:20 +0300
Message-ID: <1270713980.6754.94.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Apr 2010 08:08:06.0990 (UTC) FILETIME=[9EE7C6E0:01CAD6F2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 17:20 +0100, Ferenc Wagner wrote:
> Artem Bityutskiy <dedekind1@gmail.com> writes:
> 
> > On Tue, 2010-03-16 at 13:55 +0100, Ferenc Wagner wrote:
> > 
> >> include/linux/mtd/mtd.h contains the following snippet:
> >> 
> >> #ifdef CONFIG_MTD_DEBUG
> >> #define DEBUG(n, args...)                               \
> >>         do {                                            \
> >>                 if (n <= CONFIG_MTD_DEBUG_VERBOSE)      \
> >>                         printk(KERN_INFO args);         \
> >>         } while(0)
> >> 
> >> which conflicts with the generic debugging support in
> >> include/linux/kernel.h:
> >> 
> >> #ifdef DEBUG
> >> #define pr_devel(fmt, ...) \
> >>         printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> >> 
> >> (that is, gcc emits redefinition warnings on modules which
> >> #define DEBUG on their own and also include mtd.h)
> >> Unfortunately, the DEBUG macro is used rather heavily under
> >> drivers/mtd.  Should we resolve this somehow or is it better
> >> to just live with it?
> >
> > IMO, this MTD debug stuff is not very useful and could be just killed.
> 
> Well, I found the mtdcore debugging somewhat useful.  But anyway,
> killing it would be about as much work as renaming the macro, or using
> something standard as dev_(v)dbg or pr_debug/devel (btw. what's the
> difference?) instead.  I'm willing to do some mechanical work on either
> one if you wish.

Yeah, probalby you can transform them to dev_dbg. But the "levels" do
not seem to be available with dev_dbg, so I guess you could nuke some
higher level messages?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

