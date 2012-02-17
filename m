Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2BQR4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:56:16 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50257 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119Ab2BQR4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:56:14 -0500
X-Sasl-enc: 8kBxth4P/rUEX664WdW7lvHMtTAjp+DmCC9eNlmTSLRl 1329501372
Date: Fri, 17 Feb 2012 09:54:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, David Windsor <dwindsor@gmail.com>,
        pageexec@freemail.hu, spender@grsecurity.net
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Message-ID: <20120217175445.GC29902@kroah.com>
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

I'm referring to the fact that the use of kref in this type of error or
problem is rare.

Yes, we have these types of problems at times, but a kref doesn't seem
to be involved in them that I know of, so changing the kref code
wouldn't help here from what I can tell.

thanks,

greg k-h
