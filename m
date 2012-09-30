Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330Ab2I3Otg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 10:49:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44402 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2I3Ote (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 10:49:34 -0400
Date: Sun, 30 Sep 2012 07:49:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alex Williamson <alex.williamson@hp.com>, Alex Chiang <achiang@hp.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat()
 instead of strcat()
Message-ID: <20120930144930.GA27329@kroah.com>
References: <1348950199-30460-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348950199-30460-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 10:23:19PM +0200, Geert Uytterhoeven wrote:
> The warning check for duplicate sysfs entries can cause a buffer overflow
> when printing the warning, as strcat() doesn't check buffer sizes.
> Use strlcat() instead.

As the comment said, we knew about this, but I have never seen it, do
you know of a way to trigger it?

> Since strlcat() doesn't return a pointer to the passed buffer, unlike
> strcat(), I had to convert the nested concatenation in sysfs_add_one() to
> an admittedly more obscure comma operator construct, to avoid emitting code
> for the concatenation if CONFIG_BUG is disabled.

That's a fun construct, nice work.

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: stable@vger.kernel.org

Given that I don't know of any way to actually hit this problem, is it
really needed for older kernel releases?

thanks,

greg k-h
