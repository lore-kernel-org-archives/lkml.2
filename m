Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2EMQxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:53:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19082 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2EMQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:53:18 -0400
Date: Sun, 13 May 2012 19:56:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 02/11] persistent_ram: Fix buffer size clamping during
 writes
Message-ID: <20120513165601.GC16984@mwanda>
References: <20120512001506.GA8653@lizard>
 <20120512001717.GB14782@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120512001717.GB14782@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 05:17:17PM -0700, Anton Vorontsov wrote:
> This is a longstanding bug, almost unnoticeable when calling
> persistent_ram_write() for small buffers.
> 
> But when called for large data buffers, the write routine behaves
> incorrectly, as the size may never update: instead of clamping
> the size to the maximum buffer size, buffer_size_add_clamp() returns
> an error (which is never checked by the write routine, btw).
> 
> To fix this, we now use buffer_size_add() that actually clamps the
> size to the max value.
> 
> Also remove buffer_size_add_clamp(), it is no longer needed.
> 

Say if you did notice it, what would that look like?  It's just that
something gets lost instead of written to the screen right?

regards,
dan carpenter


