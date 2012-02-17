Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2BQR4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:56:44 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58045 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab2BQR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:56:12 -0500
X-Sasl-enc: tTim0FF7dWSEYs84Y6DKRqQZ5pk11Wt+K7eTEzxly5UF 1329501371
Date: Fri, 17 Feb 2012 09:53:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>,
        pageexec@freemail.hu, spender@grsecurity.net
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Message-ID: <20120217175322.GB29902@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217075945.GA2831@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 11:59:45AM +0400, Vasiliy Kulikov wrote:
> Hi,
> 
> > And in all that time, I've never seen an instance where you can overflow
> > the reference count,
> 
> Do you mean that the overflow is theoretically impossible or that this
> type of programmer error is rare?
> 
> If the former, it is only 2**32 incs - if you can find open() implementation
> with a missing atomic_dec() in error path and you can call open() faster than
> 10000 times per second, you can overflow the counter in ~4 days.
> 
> If the latter, it is just a question of finding missing put() in some triggerable
> error path.  Kees has already posted a link to a bug with a missing fput().
> 
> 
> BTW, moving from atomic_t to 64 bit refcounter would kill the possibility of
> overflow.  Unfortunately, AFAIU, 64 bit operations are not atomic on some 64 bit
> archs.

Can we switch it on those arches where it is an atomic operation?  That
would be a nice simple solution.

thanks,

greg k-h
