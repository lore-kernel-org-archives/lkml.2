Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2KRT70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:59:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49677 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2KRT7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:59:25 -0500
Date: Sun, 18 Nov 2012 19:59:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
Message-ID: <20121118195921.GH16916@ZenIV.linux.org.uk>
References: <CAHTX3d+Ou3_4tGqwyWFfNMSumPw2770_nhV_cTQa89k7+sxdHw@mail.gmail.com>
 <20121118054510.GE16916@ZenIV.linux.org.uk>
 <CA+55aFxncW2pEhsjg0AO9YKyvPaHyiXZMjoJZ1J8gA+8sH7HNw@mail.gmail.com>
 <20121118.140332.1273544560009594278.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118.140332.1273544560009594278.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 02:03:32PM -0500, David Miller wrote:
> > I have absolutely no objections. sigaltstack has always been kind of
> > messy, and made worse by the fact that it gets effectively no testing
> > (because it's generally not used by normal code and even code that
> > uses it tends to use it only for very uncommon events). So forcing all
> > the sigaltstack code into generic code and at least avoiding the
> > "different architectures can get things subtly - or not so subtly -
> > wrong in different ways" sounds like a good thing.
> 
> FWIW, if folks are looking for testcases there are a small number in
> glibc, a quick grep shows:
> 
> nptl/tst-cancel20.c
> nptl/tst-cancel21.c
> nptl/tst-signal6.c
> debug/tst-longjmp_chk2.c
> 
> LTP probably has a bunch too.

Might be a good idea to start adding tests/* in the kernel tree, perhaps?
Ones in glibc had been present prior to the LGPLv3 clusterfuck, by the
look of it...
