Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab2GaQYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:24:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49634 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2GaQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:24:24 -0400
Date: Tue, 31 Jul 2012 12:15:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, x86@kernel.org
Subject: Re: [PATCH] extend_brk and fixes to users of extend_brk (v1).
Message-ID: <20120731161515.GQ4789@phenom.dumpdata.com>
References: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
 <5017FE81.3080903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5017FE81.3080903@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 08:49:21AM -0700, H. Peter Anvin wrote:
> On 07/31/2012 03:42 AM, Konrad Rzeszutek Wilk wrote:
> >
> >  [PATCH 3/3] x86: Let extend_brk return a NULL pointer instead of
> >
> >makes extend_brk not do BUG_ON and instead just return NULL. This allows
> >us to handle the bootup issues more gracefully.
> >
> 
> NAK.  The whole point of the brk allocator is that users specify the
> upper limit on what they may need and stick to it.  Hence it is a
> fatal code bug if that is ever exceeded.  We want to catch those
> errors, not "handle" them.

OK, thanks for pointing that out.
> 
> This means you're either abusing the brk allocator to do something
> it is not meant to do... which may mean you can a failure in *other*
> code, or you have a bug in your code that you haven't fixed.

Its the latter - and of one of the patches in this patchset fixes that.

Will drop the one that alter extend_brk.
Thanks!
