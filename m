Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0KLKyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:54:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34375 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab0KLKyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:54:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WtLpnBr2vF3wtmbpqUdhpeLXiVx/gIBFs9mUk4GxQY2EyR/TNjVTkCQ/gLsbuT5WEb
         5oHSHEAhjMw7HT9UIL/sznbuugw3gmRJ00+5M9+LIAih1gqti8r5raVXrkNFO+2Yf4xW
         /Pygsf6SQ8ojAFApGdmTvQgRT/wWmcP9PMkeU=
Date: Fri, 12 Nov 2010 11:53:58 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kyle Moffett <kyle@moffetthome.net>, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 0/7] system time changes notification
Message-ID: <20101112105358.GA20425@riccoc20.at.omicron.at>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost>
 <20101111205123.GC10585@shisha.kicks-ass.net>
 <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6>
 <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
 <20101112092504.6b8db05b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112092504.6b8db05b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 09:25:04AM +0000, Alan Cox wrote:
> > #define CLOCK_FD 0x80000000
> > fd = open("/dev/clock/realtime", O_RDWR);
> > poll(fd);
> > clock_gettime(CLOCK_FD|fd, &ts);
> > [...]
> 
> Oh please. Can we not manage to vaguely follow the direction of other
> syscalls and instead of magic flag hacks just add
> 
> 	fclock_gettime

Did you see my recent post on dynamic clock ids, from Nov 4th?
It implements the clock lifetime cycle, and I would like to here your
comments on that.

I did not implement the clock_* syscalls in new forms as fclock_* but
will do so if there is agreement about it.

IMHO, from the application point of view, it would be nicer to be able
to mix and match dynamic clock ids with the CLOCK_ ids using a
clockid_t and the existing posix clock_* calls.

Thanks,
Richard
