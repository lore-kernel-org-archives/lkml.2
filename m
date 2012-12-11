Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2LKXSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:18:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34116 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2LKXSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:18:20 -0500
Date: Tue, 11 Dec 2012 15:18:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Benedikt Spranger <b.spranger@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de,
        Alexander.Frank@eberspaecher.com
Subject: Re: [PATCH 1/2] uio: add warning to documentation
Message-ID: <20121211231816.GA23621@kroah.com>
References: <1355267523-19724-1-git-send-email-b.spranger@linutronix.de>
 <1355267523-19724-2-git-send-email-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355267523-19724-2-git-send-email-b.spranger@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 12:12:01AM +0100, Benedikt Spranger wrote:
> The documentation has no clear statement to the POSIX 1003.1 mmap()
> feature, wich allows open(), mmap(), close() while the mmaped pointer is valid.
> The release() hook inveigled driver programmer to activate owermanagement
> functuonality in the release hook. This may harm.
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> ---
>  Documentation/DocBook/uio-howto.tmpl |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index ac3d001..59a886d 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -499,8 +499,13 @@ device is actually used.
>  <listitem><para>
>  <varname>int (*release)(struct uio_info *info, struct inode *inode)
>  </varname>: Optional. If you define your own
> -<function>open()</function>, you will probably also want a custom
> +<function>release()</function>, you will probably also want a custom
>  <function>release()</function> function.

That sentance no longer makes sense.

> +</para><para>CAVE: The release hook may be processed, even if a mmap is aktive.

Huh?

> +Disabling clocks or other powermanagement functionality may cause a system
> +crash, hangup or other unwanted sideeffects.
> +</para><para><emphasis>The mmap() function shall add an extra reference to the file associated with the file descriptor fildes which is not removed by a subsequent close() on that file descriptor. This reference shall be removed when there are no more mappings to the file.</emphasis></para><para>
> +<link xlink:href="http://pubs.opengroup.org/onlinepubs/009695399/functions/mmap.html">IEEE Std 1003.1, 2004 Edition, mmap()</link>

It's not up to us to document the mmap system call here, you should know
how to use it if you write a program with it, right?

Sorry, this patch isn't acceptable at all.

greg k-h
