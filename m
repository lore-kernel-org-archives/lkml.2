Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2DGVPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 17:15:20 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40128 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab2DGVPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 17:15:18 -0400
Date: Sat, 7 Apr 2012 17:15:12 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
Message-ID: <20120407211512.GC11295@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
 <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
 <20120407024941.GB11295@thunk.org>
 <CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 08:01:36PM -0700, Luis R. Rodriguez wrote:
> > I also really don't see how this helps License compliance folks.  If
> > the BSD folks trying to figure out whether or not they can use some
> > piece of code, "GPL-Compatible" is no more useful than as "Dual
> > BSD/GPL".  In fact, Dual BSD/GPL might actually be more useful since
> > at least to me it says it can be used under the BSD or GPL license,
> > which is precisely what the BSD folks need.
> 
> If we are OK with this thread serving as documentation for this then
> so be it, but I still prefer for this to be clarified more. *I* am
> comfortable with this but I know other vendors who did try to achieve
> the same sharing had quite a bit of time trying to validate the
> approach.

I would rather think the obvious clarification would be reading the
d*mn copyright headers.  That's going to have much more weight in a
legal dispute in any case.  If the answer is that the Linux Foundation
needs to have a bit more basic training about what a Dual License
means in its license compliance services, maybe that's the right thing
--- although if a lawyer doesn't understand how dual licenses work,
I'd suggest that the company find a better lawyer....

> I rather speed help clarify this is a reasonable approach
> and also avoid flamewars like the ones we faced when developers eons
> ago though that we *had* to GPL the OpenBSD ar5k HAL when we ported it
> to Linux for use in ath5k.

So this is a different issue.  I assume you are referring to the fact
that include/linux/license.h's license_is_gpl_compatible() doesn't
have a pure BSD option?  If that's the issue, then lobby for adding
the line:

+	|| strcmp(license, "BSD") == 0

If you are really worried about people being upset that currently, you
have to explicitly add a GPL license to BSD-licensed driver code
before it gets imported into the kernel, and you are trying to
sidestep the issue by adding a "GPL-Compatible" license (on the
grounds that a BSD-only license qualifies as GPl-Compatible), let's
have that debate openly, instead of trying to side-step it by adding
"GPL-compatible" to include/linux/license.h and allowing BSD-only
modules to use GPL-only symbols via a back door.

Regards,

							- Ted
