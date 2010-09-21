Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0IUXUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:20:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab0IUXUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:20:43 -0400
Date: Tue, 21 Sep 2010 16:19:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Hogan <james@albanarts.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Dave Airlie <airlied@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        James Simmons <jsimmons@infradead.org>
Subject: Re: [PATCH] fbmem: Fix fb_read, fb_write unaligned accesses.
Message-Id: <20100921161950.b7f45273.akpm@linux-foundation.org>
In-Reply-To: <201009180123.48303.james@albanarts.com>
References: <201009180123.48303.james@albanarts.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Sep 2010 01:23:47 +0100
James Hogan <james@albanarts.com> wrote:

> Apologies for corrupted patch. I'll try again.
> Comments? I'd also appreciate if somebody familiar with sbus on sparc
> could check this patch is sane since I know virtually nothing about sbus
> and am not in a position to compile for sparc, let alone test on it:
> 
> fb_{read,write} access the framebuffer using lots of fb_{read,write}l's
> but don't check that the file position is aligned which can cause
> problems on some architectures which do not support unaligned accesses.

What are these "problems"?

I'd have thought they would be fairly fatal, in which case this is a
high-priority patch.  But I'd also have thought that the problems would
have been noted before now.

So I assume that you're doing something which nobody has done before.

Confused.  Help?

> Since the operations are essentially memcpy_{from,to}io, new
> fb_memcpy_{from,to}fb macros have been defined and these are used
> instead.
> 
> For Sparc, fb_{read,write} macros use sbus_{read,write}, so this defines
> new sbus_memcpy_{from,to}io functions the same as memcpy_{from,to}io but
> using sbus_{read,write}b instead of {read,write}b.
