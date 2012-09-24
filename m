Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2IXUx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:53:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36927 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2IXUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:53:24 -0400
Date: Tue, 25 Sep 2012 00:53:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Salter <msalter@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: sys_kcmp
Message-ID: <20120924205318.GK16532@moon>
References: <20120922114549.GA11610@moon>
 <20120922132046.GA4260@flint.arm.linux.org.uk>
 <20120922114723.d7f07fb6.akpm@linux-foundation.org>
 <1348503709.20929.40.camel@deneb.redhat.com>
 <20120924164942.GH16532@moon>
 <20120924174256.GD24172@moon>
 <87lifzuvey.fsf@xmission.com>
 <20120924185119.GI16532@moon>
 <20120924203512.GF24172@moon>
 <87bogvup4w.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bogvup4w.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 01:44:47PM -0700, Eric W. Biederman wrote:
> Cyrill Gorcunov <gorcunov@openvz.org> writes:
> 
> > On Mon, Sep 24, 2012 at 10:51:19PM +0400, Cyrill Gorcunov wrote:
> >> > I expect what you want is a call to access_ok, rather than hard coding
> >> > details about task layout here.  This test certainly looks wrong
> >> > for a 32bit process on a 64bit kernel. If I read your test right it
> >> > appears I can set values of say 0x100000000 on a 32bit process...
> >> > 
> >> > As for mmap_min_addr I would expect your find_vma check would make that
> >> > test unnecessary, simply by not finding a vma...
> >> 
> >> Good point, Eric, thanks! I'm cooking a new patch now.
> >
> > Btw, Eric, I somehow miss one bit -- how would you set this 0x100000000
> > if TASK_SIZE is a macro which does check for TIF_ADDR32 and sets limit
> > acordingly? What i'm missing?
> 
> How odd.  Last time I had looked TASK_SIZE was a simple constant.

Ah, I see.

> Still I wonder a little if all architectures currently run from 0 to
> TASK_SIZE, for address space available.  I seem to remember there have
> been some exceptions to that rule.  But I can't recall what they were.

Actually I;ve tuned up the code to use access_ok instead but now I'm trying
to fugure out situation if it can somehow affect c/r process (well, i've
ran all test cases we use for c/r and all are passed well, but still...).

Mark, after some more thinking, I agree that your proposal with min-address
should work better than mine explicit CONFIG_MMU. Could you please send
your patch for that? As to access_ok -- gimme some more time, i need to double
check everything and I'll patch the code on top of your patch a bit later, ok?
