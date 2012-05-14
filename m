Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2ENEU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:20:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50611 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2ENEU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:20:56 -0400
Date: Sun, 13 May 2012 21:20:51 -0700
From: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: "'mina86@mina86.com'" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "'balbi@ti.com'" <balbi@ti.com>, "'hpa@zytor.com'" <hpa@zytor.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-usb@vger.kernel.org'" <linux-usb@vger.kernel.org>
Subject: Re: [Resend PATCH] tools/usb: fix a makefile bug
Message-ID: <20120514042051.GC9750@kroah.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A0629F2@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A0629F2@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 03:17:42AM +0000, Du, ChangbinX wrote:
> I try to compile tools/usb foler, but got below error(gcc version
> 4.6.3):
> 	tools/usb/testusb.c:516: undefined reference to `pthread_create'
> 	tools/usb/testusb.c:541: undefined reference to `pthread_join'
> The reason is the makefile puts source files behind of compiler option
> "-l". For gcc(and clang), it reads compiler options in order from left
> to right. When compiler gets a source file, it starts parsing it and try
> to resolve all symbols invoked. If compiler can not resolve a symbol, it
> will read --remain-- options and try get a definition of the symbol. So,
> if we put source file behind of "-l" option, the specified library will
> not work.
> 
> Signed-off-by: Du Changbin <changbinx.du@intel.com>

I think that's a regression in your version of gcc, as 4.6.2 here works
just fine with no errors.

What distro's version of gcc are you using here?  What changed between
4.6.2 and 4.6.3 that would do this?

I just tried 4.5.3 and it worked just fine as well.

I'm thinking something might be messed up on your end here, and this
patch isn't really needed.

thanks,

greg k-h
