Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0JCPdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 11:33:18 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:49841 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751855Ab0JCPdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 11:33:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zz3Ac2AKmKYi2SlVygdj0BapGSGY+80fIGEr+wnd/bGNB3+FF/sIOzvRIrmqbbBTUtu/mpCFIC+GmtgtaWcJFnlSILfsCbkdgB4ukuKC/9Dmbw5L6YyMRUg/Vpy4LEHo;
Date: Sun, 3 Oct 2010 08:32:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [git pull] i915 regressions
Message-ID: <20101003083238.55885ac3@jbarnes-x201>
In-Reply-To: <8u3s94$gm76dr@orsmga002.jf.intel.com>
References: <8u3s94$gm76dr@orsmga002.jf.intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 208.86.38.114 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Oct 2010 11:33:36 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Hi Linus,
> 
>   still a fair few regressions popping up in the i915 driver. Julia
> spotted an old bug in our error handling that could cause the
> aperture to be consumed with unpinnable buffers, Keith found that the
> wait-for-vblank handling changes were not correct for DP, Jesse
> failed at basic math (and nobody spotted the mistake!) and I

I think I'm innocent on this one!  I think Eric just introduced a merge
error when he pulled in the i915 changes for IPS.  I was using do_div
(which modifies the first arg), but Eric changed to to div_u64 to fix a
build error of some kind, but forgot to fix things up due to the
changed semantics.

At any rate, it's a good fix and gives the IPS driver good GMCH power
values again.

-- 
Jesse Barnes, Intel Open Source Technology Center
