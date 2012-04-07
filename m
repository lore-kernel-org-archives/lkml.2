Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2DGCtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 22:49:49 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:49941 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab2DGCtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 22:49:47 -0400
Date: Fri, 6 Apr 2012 22:49:41 -0400
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
Message-ID: <20120407024941.GB11295@thunk.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 05:51:51PM -0700, Luis R. Rodriguez wrote:
> 
> Its a good point that we are not declaring the exact license used for
> software, and while that is useful the "Dual BSD/GPL" tag is
> misleading. As I see it there are four options:

So the real question is what is the purpose of MODULE_LICENSE()?
Specifically, is it intended for anything other than to tell the that
this module is OK to use EXPORT_SYMBOL_GPL symbols?

Your patch which changes things like

MODULE_LICENSE("Dual BSD/GPL");

to 

MODULE_LICENSE("GPL-Compatible");

in my opinion, muddles things even more, since now in some cases
MODULE_LICENSE() will name a specific license (i.e., GPL), and in
other cases, a set of licenses (i.e., GPL-Compatible).  After all,
isn't a GPL license by definition GPL-compatible?  So why not change
*all* MODULE_LICENSE(GPL) statements to be
MODULE_LICENSE(GPL-Compatible)?  If that seems like a large, pointless
patch, then maybe it's not worth it to change "Dual BSD/GPL" to
"GPL-Compatible".

I also really don't see how this helps License compliance folks.  If
the BSD folks trying to figure out whether or not they can use some
piece of code, "GPL-Compatible" is no more useful than as "Dual
BSD/GPL".  In fact, Dual BSD/GPL might actually be more useful since
at least to me it says it can be used under the BSD or GPL license,
which is precisely what the BSD folks need.

Regards,

						- Ted
