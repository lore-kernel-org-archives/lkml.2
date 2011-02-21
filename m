Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1BUObL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab1BUObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:31:10 -0500
Date: Mon, 21 Feb 2011 15:30:23 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@novell.com>, Larry Woodman <lwoodman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110221143023.GF13092@random.random>
References: <4D4B1392.5090603@goop.org>
 <20110204012109.GP5843@random.random>
 <4D4C6F45.6010204@goop.org>
 <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
 <20110217101941.GH2380@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217101941.GH2380@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:19:41AM +0100, Johannes Weiner wrote:
> So Xen needs all page tables protected when pinning/unpinning and
> extended page_table_lock to cover kernel range, which it does nowhere
> else AFAICS.  But the places it extended are also taking the pgd_lock,
> so I wonder if Xen could just take the pgd_lock itself in these paths
> and we could revert page_table_lock back to cover user va only?
> Jeremy, could this work?  Untested.

If this works for Xen, I definitely prefer this.

Still there's no point to insist on _irqsave if nothing takes the
pgd_lock from irq, so my patch probably should be applied anyway or
it's confusing and there's even a comment saying pgd_dtor is called
from irq, if it's not it should be corrected. But then it becomes a
cleanup notafix.
