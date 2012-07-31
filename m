Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2GaRi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:38:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43658 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2GaRi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:38:27 -0400
Date: Tue, 31 Jul 2012 13:29:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ian.Campbell@citrix.com, x86@kernel.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] extend_brk and fixes to users of extend_brk
 (v1).
Message-ID: <20120731172916.GD29533@phenom.dumpdata.com>
References: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
 <5017FE81.3080903@zytor.com>
 <20120731161515.GQ4789@phenom.dumpdata.com>
 <501826EF0200007800091AE9@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501826EF0200007800091AE9@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 05:41:51PM +0100, Jan Beulich wrote:
> >>> On 31.07.12 at 18:15, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Tue, Jul 31, 2012 at 08:49:21AM -0700, H. Peter Anvin wrote:
> >> This means you're either abusing the brk allocator to do something
> >> it is not meant to do... which may mean you can a failure in *other*
> >> code, or you have a bug in your code that you haven't fixed.
> > 
> > Its the latter - and of one of the patches in this patchset fixes that.
> 
> But then you also can't assume that fitting a 2Gb MMIO hole will
> suffice; I have a machine here that I can configure to have a
> 3Gb hole, so I think you really need to be on the safe side and
> allow to cover all the way up to 4Gb with the space you reserve.

I have a patch to address that were the P2M leafs are re-used (the
ones that either full of 1:1 PFNs or INVALID_P2M_ENTRY). But
somehow its hitting a bug..
> 
> Jan
