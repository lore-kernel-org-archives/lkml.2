Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1BVNuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 08:50:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1BVNun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 08:50:43 -0500
Date: Tue, 22 Feb 2011 14:49:56 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Johannes Weiner <jweiner@redhat.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] fix pgd_lock deadlock
Message-ID: <20110222134956.GU13092@random.random>
References: <20110207232045.GJ3347@random.random>
 <20110215190710.GL5935@random.random>
 <alpine.LFD.2.00.1102152020590.26192@localhost6.localdomain6>
 <20110215195450.GO5935@random.random>
 <alpine.LFD.2.00.1102152102530.26192@localhost6.localdomain6>
 <20110216183304.GD5935@random.random>
 <20110217101941.GH2380@redhat.com>
 <20110221143023.GF13092@random.random>
 <20110221145350.GH25382@redhat.com>
 <4D6378760200007800033104@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6378760200007800033104@vpn.id2.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 07:48:54AM +0000, Jan Beulich wrote:
> A possible alternative would be to acquire the page table lock
> in vmalloc_sync_all() only in the Xen case (perhaps by storing
> NULL into page->index in pgd_set_mm() when not running on
> Xen). This is utilizing the fact that there aren't (supposed to
> be - for non-pvops this is definitely the case) any TLB flush IPIs
> under Xen, and hence the race you're trying to fix doesn't
> exist there (while non-Xen doesn't need the extra locking).

That's sure ok with me. Can we use a global runtime to check if the
guest is running under Xen paravirt, instead of passing that info
through page->something?
