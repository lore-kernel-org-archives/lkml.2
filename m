Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2GQTPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:15:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63904 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab2GQTPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:15:07 -0400
Date: Tue, 17 Jul 2012 12:15:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        linux-kernel@vger.kernel.org, arve@android.com,
        Jesper Juhl <jj@chaosbits.net>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] pstore: Headers should include all stuff they use
Message-ID: <20120717191502.GA8048@kroah.com>
References: <20120717180918.GA18671@lizard>
 <1342548840-22404-1-git-send-email-anton.vorontsov@linaro.org>
 <20120717181944.GA21957@kroah.com>
 <20120717183707.GA24056@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120717183707.GA24056@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 11:37:07AM -0700, Anton Vorontsov wrote:
> Headers should really include all the needed prototypes, types, defines
> etc. to be self-contained. This is a long-standing issue, but apparently
> the new tracing code unearthed it (SMP=n is also a prerequisite):
> 
> In file included from fs/pstore/internal.h:4:0,
>                  from fs/pstore/ftrace.c:21:
> include/linux/pstore.h:43:15: error: field ‘read_mutex’ has incomplete type
> 
> While at it, I also added the following:
> 
> linux/types.h -> size_t, phys_addr_t, uXX and friends
> linux/spinlock.h -> spinlock_t
> linux/errno.h -> Exxxx
> linux/time.h -> struct timespec (struct passed by value)
> struct module and rs_control forward declaration (passed via pointers).
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
> 
> On Tue, Jul 17, 2012 at 11:19:44AM -0700, Greg Kroah-Hartman wrote:
> > On Tue, Jul 17, 2012 at 11:13:59AM -0700, Anton Vorontsov wrote:
> > > Headers should really include all the needed prototypes, types, defines
> > 
> > <snip>
> > 
> >   Content-Transfer-Encoding: base64
> > 
> > That's not a nice way to send patches out, care to fix this and resend?
> 
> I used 'git send-email' as normal, and it said:
> 
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> 
> OK, I checked what vger.kernel.org received, and it still says:
> 
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> And I see the email readable in the text editor.
> 
> OK, with linux_banner I got what the problem is, but where base64
> came from?.. :-/

It looks like the devel mailing list does this conversion, ugh, mailman
sucks at times.

Sorry about that,

greg k-h
