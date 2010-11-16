Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0KPTmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:42:08 -0500
Received: from kroah.org ([198.145.64.141]:51798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618Ab0KPTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:42:07 -0500
Date: Tue, 16 Nov 2010 11:33:28 -0800
From: Greg KH <greg@kroah.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] staging: ft1000: Copy from user into correct data
Message-ID: <20101116193328.GA12492@kroah.com>
References: <1289492965.12418.262.camel@gandalf.stny.rr.com>
 <AANLkTikz7nxaE=Xs=JUwoM0sXNnDcNrpsrTTBzJkysAD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikz7nxaE=Xs=JUwoM0sXNnDcNrpsrTTBzJkysAD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:14:26AM +0100, Belisko Marek wrote:
> Hi Steven,
> 
> On Thu, Nov 11, 2010 at 5:29 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > While doing a ktest.pl I used a MIN_CONFIG that had STAGING enabled, and
> > a randconfig with CONFIG_DEBUG_STRICT_USER_COPY_CHECKS enabled caught
> > the following bug:
> >
> > In file included from /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/include/asm/uaccess.h:571:0,
> >                 from /home/rostedt/work/autotest/nobackup/linux-test.git/include/linux/poll.h:14,
> >                 from /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:32:
> > In function 'copy_from_user',
> >    inlined from 'ft1000_ChIoctl' at /home/rostedt/work/autotest/nobackup/linux-test.git/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:702:36:
> > /home/rostedt/work/autotest/nobackup/linux-test.git/arch/x86/include/asm/uaccess_32.h:212:26: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
> >
> >
> > Looking at the code it was obvious what the problem was. The pointer
> > dpram_data was being allocated but the address was being written to.
> > Looking at the comment above the code shows that it use to write into an
> > element of that pointer where the '&' is appropriate. But now that it
> > writes to the pointer itself, we need to remove the '&' otherwise we
> > write over the pointer and not into the data it points to.
> Good catch but anyway this interface is removed. Already send patches to Greg-KH
> but there was some patch problem so they're not applied to next yet.

But this patch is correct, and I don't have your other patches in my
inbox, so I'm going to apply this one.

Please rebase your fixes on the next linux-next and all should be fine.

thanks,

greg k-h
