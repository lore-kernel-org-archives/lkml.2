Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0KIUKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:10:19 -0500
Received: from mail.perches.com ([173.55.12.10]:4777 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab0KIUKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:10:15 -0500
Subject: Re: [PATCH V2] include/linux/kernel.h: Move logging bits to
 include/linux/logging.h
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101109200118.GA13016@core2.telecom.by>
References: <1289281110-8559-1-git-send-email-joe@perches.com>
	 <AANLkTime8YvyHysZF5sX6V2mXWJ0FUtdecpVFgRGqYm6@mail.gmail.com>
	 <1289328235.1823.108.camel@Joe-Laptop>
	 <AANLkTi=rTw+ByhdGc9prjwvqt_TT=NmOYzEjns1LffLC@mail.gmail.com>
	 <20101109200118.GA13016@core2.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 12:10:13 -0800
Message-ID: <1289333413.28590.29.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 22:01 +0200, Alexey Dobriyan wrote:
> On Tue, Nov 09, 2010 at 10:49:19AM -0800, Linus Torvalds wrote:
> > On Tue, Nov 9, 2010 at 10:43 AM, Joe Perches <joe@perches.com> wrote:
> > >
> > > diff from V1 - Don't add pr_<level>_once macros
> > >
> > >  include/linux/kernel.h  |  244 +--------------------------------------
> > >  include/linux/logging.h |  295 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 296 insertions(+), 243 deletions(-)
> > >  create mode 100644 include/linux/logging.h
> > 
> > So where do the extra 53 lines come from now?
> > 
> > This still is clearly not just code movement, and it's impossible for
> > me to see what actually changed. Something must have.
> 
> Why linux_banner is moved?
> Why linux_proc_banner is moved?

It's only used by a printk.

> Why header is not named printk.h?

No particular reason nor any particular objection.

> Why random stuff like log_buf_kexec_setup() and hexdump is moved?

hexdump functions are logging message related
as is log_buf_kexec_setup.

hexdump should/will eventually have an
#ifdef CONFIG_PRINTK
	external function prototypes
#else
static inline void
hex_dump_to_buffer(const void *buf, size_t len,
		   int rowsize, int groupsize,
		   char *linebuf, size_t linebuflen, bool ascii) {}
static inline void
print_hex_dump(const char *level, const char *prefix_str,
	       int prefix_type, int rowsize, int groupsize,
	       const void *buf, size_t len, bool ascii) {}
static inline void
print_hex_dump_bytes(const char *prefix_str, int prefix_type,
		     const void *buf, size_t len) {}
#endif

so the static strings of the call sites can be eliminated
when !CONFIG_PRINTK.


