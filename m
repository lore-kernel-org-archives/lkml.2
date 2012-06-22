Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933Ab2FVJrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 05:47:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58097 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761896Ab2FVJrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 05:47:05 -0400
Date: Fri, 22 Jun 2012 10:47:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ozan ??a??layan <ozancag@gmail.com>
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org
Subject: Re: get_unused_fd and get_unused_fd_flags
Message-ID: <20120622094702.GD14083@ZenIV.linux.org.uk>
References: <CAFub=KRdM2Mc1RXa_HfYO8gSxpyCpsP9Z1YHRULCLwNDnXQyEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFub=KRdM2Mc1RXa_HfYO8gSxpyCpsP9Z1YHRULCLwNDnXQyEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 12:33:35PM +0300, Ozan ??a??layan wrote:
> But get_unused_fd_flags() is implemented through a macro:
> 
> #define get_unused_fd_flags(flags) alloc_fd(0, (flags))
> 
> Both are wrappers around alloc_fd(). I'm quite new to this stuff but
> why there's an asymmetry in here? One is exposed, the other is not.

Because get_unused_fd_flags() never had been exported.  And
default policy for exports is "Don't, unless somebody can
demonstrate a clear need that can't be handled in other
ways".

> (BTW: I'm doing compat-drm stuff for GSoC and I have to call
> get_unused_fd_flags() but since alloc_fd() is not exported, this
> doesn't work.)

Details of that "have to", please.  Note that existing modular uses of
get_unused_fd() tend to be rather fishy; if anything, I'd expect
get_unused_fd() eventually becoming internal-only, if we manage to
pull that off.
