Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2IXUfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:35:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52222 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2IXUfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:35:19 -0400
Date: Tue, 25 Sep 2012 00:35:12 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mark Salter <msalter@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: sys_kcmp
Message-ID: <20120924203512.GF24172@moon>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
 <20120922114549.GA11610@moon>
 <20120922132046.GA4260@flint.arm.linux.org.uk>
 <20120922114723.d7f07fb6.akpm@linux-foundation.org>
 <1348503709.20929.40.camel@deneb.redhat.com>
 <20120924164942.GH16532@moon>
 <20120924174256.GD24172@moon>
 <87lifzuvey.fsf@xmission.com>
 <20120924185119.GI16532@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924185119.GI16532@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 10:51:19PM +0400, Cyrill Gorcunov wrote:
> > I expect what you want is a call to access_ok, rather than hard coding
> > details about task layout here.  This test certainly looks wrong
> > for a 32bit process on a 64bit kernel. If I read your test right it
> > appears I can set values of say 0x100000000 on a 32bit process...
> > 
> > As for mmap_min_addr I would expect your find_vma check would make that
> > test unnecessary, simply by not finding a vma...
> 
> Good point, Eric, thanks! I'm cooking a new patch now.

Btw, Eric, I somehow miss one bit -- how would you set this 0x100000000
if TASK_SIZE is a macro which does check for TIF_ADDR32 and sets limit
acordingly? What i'm missing?
