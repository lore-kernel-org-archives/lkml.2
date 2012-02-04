Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2BDSdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:33:08 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53950 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2BDSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:33:07 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.15.19
Date: Sat, 4 Feb 2012 10:32:59 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Kconfig and toolchain dependencies
Message-ID: <20120204183259.GA28208@leaf>
References: <4F2C51A5.1040800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2C51A5.1040800@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:29:09PM -0800, H. Peter Anvin wrote:
> It seems relatively straightforward to do if we were to manifest some
> CONFIG_ variables based on the target toolchain, e.g.
> 
> CONFIG_GCC=0x040601
> 
> ... and perhaps do other tests.  I suspect we would run the tests less
> frequently than what we do right now with the tests embedded in the
> Makefile.
> 
> Does anyone have a feel for if this would be a good addition, and if so
> where it best fits into the chain?

This seems like a *great* idea.  Unfortunately, a quick look at the
implementation of kbuild suggests that it doesn't currently implement
numeric comparisons (<, <=, >, >=), only equality (= and !=).  Most of
the time, a Kconfig file will want to write "depends GCC >=
some_version".

Looking at scripts/kconfig/expr.c, it doesn't look that hard to add,
though.

- Josh Triplett
