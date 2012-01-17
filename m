Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2AQXzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:55:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2AQXzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:55:54 -0500
Date: Tue, 17 Jan 2012 15:55:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ramoops: use pstore interface
Message-Id: <20120117155552.be287c61.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jJ_RWNKC7QgGXYgLFv6QCmkjw4z11WVcB=8BFacye0a3Q@mail.gmail.com>
References: <20120107171516.GE2618@outflux.net>
	<20120117135921.3f68701e.akpm@linux-foundation.org>
	<CAGXu5jJ_RWNKC7QgGXYgLFv6QCmkjw4z11WVcB=8BFacye0a3Q@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 15:48:25 -0800
Kees Cook <keescook@chromium.org> wrote:

> > Note that pstore_get_records() will treat the -ve errno returns from
> > ->read() in the same manner as EOF.  IOW, your error codes will be
> > dropped on the floor.  This appears to be a bug in pstore_get_records().
> 
> Well, IIUC, it just means the file doesn't get populated at all; there
> is no userspace interface to finding out why a file didn't appear in
> the pstore fliesystem. But yes, the specifics of the error are ignored
> by pstore_get_records(). It didn't seem wrong to produce meaningful
> codes in ramoops, though.
> 

Well, there's a printk() in there.  But it only comes out if it was
pstore_mkfile() which failed.
